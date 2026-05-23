import 'dart:async' show unawaited;

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;
import 'package:water_tracker/core/providers/app_locale_provider.dart';
import 'package:water_tracker/core/providers/app_theme_mode_provider.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:water_tracker/shared/services/notification_service.dart';
import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/shared/widgets/shimmer_placeholder.dart';
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:water_tracker/features/settings/presentation/providers/settings_provider.dart';
import 'package:water_tracker/features/settings/presentation/providers/user_weight_provider.dart';
import 'package:water_tracker/features/stats/presentation/providers/stats_provider.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';

const List<int> kReminderIntervalOptions = <int>[30, 45, 60, 90, 120];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(currentUserProvider);
    final AppLocalizations l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.settings), automaticallyImplyLeading: false),
      body: ref
          .watch(userProfileNotifierProvider)
          .when(
            data: (UserProfile p) {
              final String localeTag = Localizations.localeOf(
                context,
              ).toString();
              final AsyncValue<double?> weightAv = ref.watch(
                userWeightKgProvider,
              );
              final String weightLabel = weightAv.maybeWhen(
                data: (double? v) {
                  if (v == null) {
                    return '—';
                  }
                  final String n = NumberFormat.decimalPattern(
                    localeTag,
                  ).format(v);
                  return '$n ${l.onboardingKgSuffix}';
                },
                orElse: () => '—',
              );
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(userProfileNotifierProvider);
                  ref.invalidate(dailyWaterGoalProvider);
                  ref.invalidate(profileRollingYearStatsProvider);
                  ref.invalidate(currentStreakProvider);
                  ref.invalidate(userWeightKgProvider);
                  await ref.read(userProfileNotifierProvider.future);
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    _ProfileHero(profile: p, user: user),
                    const SizedBox(height: 20),
                    _capsSection(context, l.profileAchievements),
                    const _AchievementsStrip(),
                    const SizedBox(height: 16),
                    _capsSection(context, l.goalSection),
                    _SettingsCardWrapper(
                      child: Column(
                        children: <Widget>[
                          _designRow(
                            context,
                            icon: Icons.flag_outlined,
                            iconColor: AppColors.primary,
                            title: l.dailyGoal,
                            value: l.mlFormat(p.dailyGoalMl),
                            onTap: () =>
                                unawaited(_showGoalDialog(context, ref, p)),
                          ),
                          const Divider(height: 1),
                          _designRow(
                            context,
                            icon: Icons.person_outline,
                            iconColor: const Color(0xFF7C5BD8),
                            title: l.weightKg,
                            value: weightLabel,
                            onTap: () {
                              unawaited(_showWeightKgEditor(context, ref));
                            },
                          ),
                          const Divider(height: 1),
                          _designRow(
                            context,
                            icon: Icons.eco_outlined,
                            iconColor: const Color(0xFF3DAB72),
                            title: l.profileActivity,
                            value: l.activityMedium,
                            showChevron: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _capsSection(context, l.reminders),
                    _SettingsCardWrapper(
                      child: Column(
                        children: <Widget>[
                          SwitchListTile(
                            title: Text(l.remindersLabel),
                            value: p.reminderEnabled,
                            onChanged: (bool v) {
                              unawaited(
                                ref
                                    .read(userProfileNotifierProvider.notifier)
                                    .updateReminders(
                                      enabled: v,
                                      intervalMinutes:
                                          p.reminderIntervalMinutes,
                                      startTime: p.startTimeOfDay,
                                      endTime: p.endTimeOfDay,
                                    )
                                    .then((void _) {})
                                    .catchError((Object? e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              l.remindersError(
                                                e?.toString() ?? '',
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              );
                            },
                          ),
                          if (p.reminderEnabled) ...<Widget>[
                            const Divider(height: 1),
                            ListTile(
                              title: Text(l.reminderInterval),
                              subtitle: Text(
                                l.minutesShort(p.reminderIntervalMinutes),
                              ),
                              onTap: () {
                                unawaited(
                                  _showIntervalBottomSheet(
                                    context,
                                    ref,
                                    p,
                                    p.reminderIntervalMinutes,
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(l.reminderFrom),
                              subtitle: Text(
                                MaterialLocalizations.of(
                                  context,
                                ).formatTimeOfDay(p.startTimeOfDay),
                              ),
                              onTap: () {
                                unawaited(
                                  _pickTime(context, ref, p, isStart: true),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(l.reminderTo),
                              subtitle: Text(
                                MaterialLocalizations.of(
                                  context,
                                ).formatTimeOfDay(p.endTimeOfDay),
                              ),
                              onTap: () {
                                unawaited(
                                  _pickTime(context, ref, p, isStart: false),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  unawaited(
                                    NotificationService.instance.showImmediate(
                                      l.reminderTestTitle,
                                      l.reminderTestBody,
                                    ),
                                  );
                                },
                                child: Text(l.reminderTest),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _capsSection(context, l.appearanceSection),
                    _SettingsCardWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                            child: ref
                                .watch(appThemeModeProvider)
                                .when(
                                  data: (ThemeMode m) {
                                    return SegmentedButton<ThemeMode>(
                                      segments: <ButtonSegment<ThemeMode>>[
                                        ButtonSegment<ThemeMode>(
                                          value: ThemeMode.system,
                                          label: Text(
                                            l.themeSystem,
                                            maxLines: 1,
                                          ),
                                          icon: const Icon(
                                            Icons.brightness_auto,
                                            size: 18,
                                          ),
                                        ),
                                        ButtonSegment<ThemeMode>(
                                          value: ThemeMode.light,
                                          label: Text(
                                            l.themeLight,
                                            maxLines: 1,
                                          ),
                                          icon: const Icon(
                                            Icons.light_mode,
                                            size: 18,
                                          ),
                                        ),
                                        ButtonSegment<ThemeMode>(
                                          value: ThemeMode.dark,
                                          label: Text(l.themeDark, maxLines: 1),
                                          icon: const Icon(
                                            Icons.dark_mode,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                      selected: <ThemeMode>{m},
                                      onSelectionChanged: (Set<ThemeMode> s) {
                                        if (s.isNotEmpty) {
                                          unawaited(
                                            ref
                                                .read(
                                                  appThemeModeProvider.notifier,
                                                )
                                                .setTheme(s.first),
                                          );
                                        }
                                      },
                                    );
                                  },
                                  loading: () => const ShimmerListTileLine(),
                                  error: (Object? _, Object? __) {
                                    return Text(l.themeLoadError);
                                  },
                                ),
                          ),
                          const Divider(height: 1),
                          ref
                              .watch(appLocaleProvider)
                              .when(
                                data: (Locale loc) => ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  title: Text(l.languageSetting),
                                  trailing: DropdownButton<String>(
                                    value: loc.languageCode,
                                    underline: const SizedBox.shrink(),
                                    isDense: true,
                                    items: <DropdownMenuItem<String>>[
                                      DropdownMenuItem<String>(
                                        value: 'en',
                                        child: Text(l.languageEnglish),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'ru',
                                        child: Text(l.languageRussian),
                                      ),
                                    ],
                                    onChanged: (String? code) {
                                      if (code != null) {
                                        unawaited(
                                          ref
                                              .read(appLocaleProvider.notifier)
                                              .setLocale(Locale(code)),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                loading: () => const ListTile(
                                  title: SizedBox(height: 8),
                                  trailing: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                error: (Object? _, Object? __) =>
                                    const SizedBox.shrink(),
                              ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _capsSection(context, l.account),
                    ListTile(
                      title: Text(
                        l.logout,
                        style: const TextStyle(color: AppColors.error),
                      ),
                      leading: const Icon(Icons.logout, color: AppColors.error),
                      onTap: () {
                        unawaited(_showLogoutDialog(context, ref));
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(
                        l.deleteAccount,
                        style: const TextStyle(color: AppColors.error),
                      ),
                      leading: const Icon(
                        Icons.delete_forever_outlined,
                        color: AppColors.error,
                      ),
                      onTap: () {
                        unawaited(_showDeleteAccountDialog(context, ref));
                      },
                    ),
                    const Divider(height: 1),
                    _sectionTitle(context, l.about),
                    ListTile(
                      title: Text(l.version),
                      subtitle: const Text('1.0.0'),
                    ),
                    ListTile(
                      title: Text(l.privacy),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {
                        context.push('/settings/privacy');
                      },
                    ),
                  ],
                ),
              );
            },
            error: (Object e, Object st) {
              return Center(
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 100),
                    Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 12),
                    Text(l.profileLoadError, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        ref.invalidate(userProfileNotifierProvider);
                      },
                      child: Text(l.retry),
                    ),
                  ],
                ),
              );
            },
            loading: () {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: ShimmerListPlaceholder(tiles: 6),
              );
            },
          ),
    );
  }

  static Widget _sectionTitle(BuildContext context, String t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          t,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

Widget _capsSection(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(4, 6, 4, 10),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.06,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.55),
        ),
      ),
    ),
  );
}

class _SettingsCardWrapper extends StatelessWidget {
  const _SettingsCardWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.55)),
        boxShadow: dark
            ? null
            : <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

Widget _designRow(
  BuildContext context, {
  required IconData icon,
  required Color iconColor,
  required String title,
  String? value,
  VoidCallback? onTap,
  bool showChevron = true,
}) {
  final Color muted = Theme.of(
    context,
  ).colorScheme.onSurface.withValues(alpha: 0.55);
  final Color faint = Theme.of(
    context,
  ).colorScheme.onSurface.withValues(alpha: 0.35);
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          if (value != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: muted,
                ),
              ),
            ),
          if (showChevron) Icon(Icons.chevron_right, size: 20, color: faint),
        ],
      ),
    ),
  );
}

class _ProfileHero extends ConsumerWidget {
  const _ProfileHero({required this.profile, required this.user});

  final UserProfile profile;
  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final String locale = Localizations.localeOf(context).toString();
    final String rawName = profile.displayName?.trim().isNotEmpty == true
        ? profile.displayName!.trim()
        : (user?.email ?? l.notSet);
    final String letter = rawName.isEmpty
        ? '?'
        : String.fromCharCode(rawName.runes.first).toUpperCase();
    String member = '';
    final String? ca = user?.createdAt;
    if (ca != null && ca.isNotEmpty) {
      try {
        member = DateFormat.yMMMMd(locale).format(DateTime.parse(ca));
      } on Object {
        member = '';
      }
    }
    final AsyncValue<({int sumMl, int activeDays})> roll = ref.watch(
      profileRollingYearStatsProvider,
    );
    final AsyncValue<int> streak = ref.watch(currentStreakProvider);
    final double litersRaw = roll.maybeWhen(
      data: (({int sumMl, int activeDays}) v) => v.sumMl / 1000,
      orElse: () => 0,
    );
    final String litersStr = NumberFormat.decimalPattern(
      locale,
    ).format(double.parse(litersRaw.toStringAsFixed(1)));
    final int active = roll.maybeWhen(
      data: (({int sumMl, int activeDays}) v) => v.activeDays,
      orElse: () => 0,
    );
    final int str = streak.maybeWhen(data: (int v) => v, orElse: () => 0);
    final Color muted = theme.colorScheme.onSurface.withValues(alpha: 0.55);

    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.waterGradient,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color(0x592890D1),
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  rawName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (member.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l.profileMemberSince(member),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                    ),
                  ),
              ],
            ),
            IconButton(
              tooltip: l.name,
              onPressed: () =>
                  unawaited(_showEditNameDialog(context, ref, profile)),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            Expanded(
              child: _StatPill(
                value: '$active',
                caption: l.profileDaysStat,
                hint: l.profileRollingHint,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatPill(
                value: '$litersStr ${locale.startsWith('ru') ? 'л' : 'L'}',
                caption: l.profileDrankStat,
                hint: l.profileRollingHint,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatPill(
                value: '$str',
                caption: l.streakLabel,
                hint: l.homeStreakSubtitle,
                color: const Color(0xFFFF8A3D),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.value,
    required this.caption,
    required this.hint,
    required this.color,
  });

  final String value;
  final String caption;
  final String hint;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementsStrip extends ConsumerWidget {
  const _AchievementsStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final int streak = ref.watch(currentStreakProvider).valueOrNull ?? 0;
    final ({int sumMl, int activeDays})? roll = ref
        .watch(profileRollingYearStatsProvider)
        .valueOrNull;
    final int totalMl = roll?.sumMl ?? 0;

    final List<({IconData icon, String label, bool on})> items =
        <({IconData icon, String label, bool on})>[
          (icon: Icons.bolt_outlined, label: '7d', on: streak >= 7),
          (icon: Icons.flag_outlined, label: '30', on: streak >= 30),
          (icon: Icons.opacity_outlined, label: '100L', on: totalMl >= 100000),
          (icon: Icons.local_fire_department_outlined, label: '30d', on: false),
          (icon: Icons.eco_outlined, label: 'Eco', on: false),
          (
            icon: Icons.local_drink_outlined,
            label: '1kL',
            on: totalMl >= 1000000,
          ),
        ];

    return _SettingsCardWrapper(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.92,
          children: items.map((({IconData icon, String label, bool on}) a) {
            return Column(
              children: <Widget>[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: a.on
                        ? const LinearGradient(
                            colors: <Color>[
                              AppColors.primaryLight,
                              AppColors.primary,
                            ],
                          )
                        : null,
                    color: a.on
                        ? null
                        : theme.colorScheme.surfaceContainerHighest,
                    border: a.on
                        ? null
                        : Border.all(
                            color: theme.dividerColor,
                            style: BorderStyle.solid,
                          ),
                    boxShadow: a.on
                        ? <BoxShadow>[
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.28),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    a.icon,
                    color: a.on ? Colors.white : theme.disabledColor,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  a.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: a.on
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

Future<void> _showEditNameDialog(
  BuildContext context,
  WidgetRef ref,
  UserProfile profile,
) async {
  final AppLocalizations l = AppLocalizations.of(context);
  String name = profile.displayName ?? '';
  await showDialog<void>(
    context: context,
    builder: (BuildContext dContext) {
      return AlertDialog(
        title: Text(l.name),
        content: TextFormField(
          initialValue: name,
          decoration: InputDecoration(
            labelText: l.nameFieldLabel,
            hintText: l.nameHint,
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (String value) {
            name = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(dContext).pop();
            },
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final NavigatorState nav = Navigator.of(dContext);
              try {
                await ref
                    .read(userProfileNotifierProvider.notifier)
                    .updateDisplayName(name.trim());
                if (dContext.mounted) {
                  nav.pop();
                }
              } on Object catch (e) {
                if (dContext.mounted) {
                  ScaffoldMessenger.of(dContext).showSnackBar(
                    SnackBar(content: Text(l.errorGeneric(e.toString()))),
                  );
                }
              }
            },
            child: Text(l.save),
          ),
        ],
      );
    },
  );
}

double? _parseWeightKg(String raw) =>
    double.tryParse(raw.trim().replaceAll(',', '.'));

int _goalMlFromKg(double k) {
  final int targetMl = (k * 35).round();
  return ((targetMl / 50).round() * 50).clamp(1000, 4000).toInt();
}

Future<void> _showWeightKgEditor(BuildContext context, WidgetRef ref) async {
  final AppLocalizations l = AppLocalizations.of(context);
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  final double? existing = ref.read(userWeightKgProvider).valueOrNull;
  final TextEditingController controller = TextEditingController(
    text: existing != null
        ? (existing == existing.roundToDouble()
              ? '${existing.round()}'
              : existing.toStringAsFixed(1))
        : '',
  );
  try {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dContext) {
        return AlertDialog(
          title: Text(l.weightKg),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: l.weightExample),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dContext).pop(),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () async {
                final double? k = _parseWeightKg(controller.text);
                if (k == null || k < 1 || k > 400) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(l.invalidWeight)),
                  );
                  return;
                }
                try {
                  await ref.read(userWeightKgProvider.notifier).setKg(k);
                  final int g = _goalMlFromKg(k);
                  final Future<void> saveGoal = ref
                      .read(userProfileNotifierProvider.notifier)
                      .updateGoal(g);
                  ref.invalidate(dailyWaterGoalProvider);
                  if (dContext.mounted) {
                    Navigator.of(dContext).pop();
                  }
                  unawaited(
                    saveGoal.catchError((Object e) {
                      if (context.mounted) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(l.errorGeneric(e.toString()))),
                        );
                      }
                    }),
                  );
                } on Object catch (e) {
                  if (context.mounted) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(l.errorGeneric(e.toString()))),
                    );
                  }
                }
              },
              child: Text(l.calculateByWeight),
            ),
            FilledButton(
              onPressed: () async {
                final double? k = _parseWeightKg(controller.text);
                if (k == null || k < 1 || k > 400) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(l.invalidWeight)),
                  );
                  return;
                }
                try {
                  await ref.read(userWeightKgProvider.notifier).setKg(k);
                  if (dContext.mounted) {
                    Navigator.of(dContext).pop();
                  }
                } on Object catch (e) {
                  if (context.mounted) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(l.errorGeneric(e.toString()))),
                    );
                  }
                }
              },
              child: Text(l.save),
            ),
          ],
        );
      },
    );
  } finally {
    // Диалог закрывается асинхронно по дереву виджетов; пока TextField отписывается
    // от контроллера, dispose() нельзя вызывать сразу — иначе assert на _dependents.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });
  }
}

Future<void> _showGoalDialog(
  BuildContext context,
  WidgetRef ref,
  UserProfile profile,
) async {
  final AppLocalizations l = AppLocalizations.of(context);
  int goal = (profile.dailyGoalMl.clamp(1000, 4000) as num).toInt();
  if (goal % 50 != 0) {
    goal = (goal / 50).round() * 50;
  }
  await showDialog<void>(
    context: context,
    builder: (BuildContext dContext) {
      return StatefulBuilder(
        builder: (BuildContext dContext, void Function(void Function()) st) {
          return AlertDialog(
            title: Text(l.dailyGoal),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  l.mlFormat(goal),
                  style: Theme.of(dContext).textTheme.titleLarge,
                ),
                Slider(
                  value: goal.toDouble(),
                  min: 1000,
                  max: 4000,
                  divisions: 60,
                  label: l.mlFormat(goal),
                  onChanged: (double v) {
                    st(() {
                      goal = (v / 50).round() * 50;
                    });
                  },
                ),
                TextButton(
                  onPressed: () {
                    unawaited(
                      _showWeightForGoal(dContext, ref, (int newGoal) {
                        st(() {
                          goal = newGoal;
                        });
                      }),
                    );
                  },
                  child: Text(l.calculateByWeight),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dContext).pop();
                },
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: () {
                  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(
                    context,
                  );
                  final Future<void> save = ref
                      .read(userProfileNotifierProvider.notifier)
                      .updateGoal(goal);
                  ref.invalidate(dailyWaterGoalProvider);
                  Navigator.of(dContext).pop();
                  unawaited(
                    save.catchError((Object e) {
                      if (context.mounted) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(l.errorGeneric(e.toString()))),
                        );
                      }
                    }),
                  );
                },
                child: Text(l.save),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _showWeightForGoal(
  BuildContext parentContext,
  WidgetRef ref,
  void Function(int goalMl) onGoalComputed,
) async {
  final AppLocalizations l = AppLocalizations.of(parentContext);
  final double? existingWeight = ref.read(userWeightKgProvider).valueOrNull;
  final TextEditingController controller = TextEditingController(
    text: existingWeight == null
        ? ''
        : (existingWeight == existingWeight.roundToDouble()
              ? '${existingWeight.round()}'
              : existingWeight.toStringAsFixed(1)),
  );
  final bool? done = await showDialog<bool>(
    context: parentContext,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(l.weightKg),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(hintText: l.weightExample),
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: Text(l.ok),
          ),
        ],
      );
    },
  );
  if (done != true) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });
    return;
  }
  final double? k = double.tryParse(
    controller.text.trim().replaceAll(',', '.'),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.dispose();
  });
  if (k == null) {
    return;
  }
  await ref.read(userWeightKgProvider.notifier).setKg(k);
  final int targetMl = (k * 35).round();
  final int snapped = ((targetMl / 50).round() * 50).clamp(1000, 4000).toInt();
  onGoalComputed(snapped);
}

Future<void> _showIntervalBottomSheet(
  BuildContext context,
  WidgetRef ref,
  UserProfile profile,
  int current,
) async {
  final AppLocalizations l = AppLocalizations.of(context);
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (BuildContext c) {
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            for (final int m in kReminderIntervalOptions)
              ListTile(
                title: Text(l.minutesShort(m)),
                selected: m == current,
                onTap: () {
                  Navigator.of(c).pop();
                  unawaited(
                    ref
                        .read(userProfileNotifierProvider.notifier)
                        .updateReminders(
                          enabled: true,
                          intervalMinutes: m,
                          startTime: profile.startTimeOfDay,
                          endTime: profile.endTimeOfDay,
                        )
                        .catchError((Object? e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l.errorGeneric(e.toString())),
                              ),
                            );
                          }
                        }),
                  );
                },
              ),
          ],
        ),
      );
    },
  );
}

Future<void> _pickTime(
  BuildContext context,
  WidgetRef ref,
  UserProfile p, {
  required bool isStart,
}) async {
  final TimeOfDay initial = isStart ? p.startTimeOfDay : p.endTimeOfDay;
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initial,
  );
  if (picked == null || !context.mounted) {
    return;
  }
  if (isStart) {
    await ref
        .read(userProfileNotifierProvider.notifier)
        .updateReminders(
          enabled: p.reminderEnabled,
          intervalMinutes: p.reminderIntervalMinutes,
          startTime: picked,
          endTime: p.endTimeOfDay,
        );
  } else {
    await ref
        .read(userProfileNotifierProvider.notifier)
        .updateReminders(
          enabled: p.reminderEnabled,
          intervalMinutes: p.reminderIntervalMinutes,
          startTime: p.startTimeOfDay,
          endTime: picked,
        );
  }
}

Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
  final AppLocalizations l = AppLocalizations.of(context);
  final bool? r = await showDialog<bool>(
    context: context,
    builder: (BuildContext c) {
      return AlertDialog(
        title: Text(l.logoutTitle),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(c).pop(false);
            },
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(c).pop(true);
            },
            child: Text(l.logout),
          ),
        ],
      );
    },
  );
  if (r == true) {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } on Object catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l.logoutFailed}: $e')));
      }
    }
  }
}

Future<void> _showDeleteAccountDialog(BuildContext context, WidgetRef ref) async {
  final AppLocalizations l = AppLocalizations.of(context);
  final bool? r = await showDialog<bool>(
    context: context,
    builder: (BuildContext c) {
      return AlertDialog(
        title: Text(l.deleteAccountTitle),
        content: Text(l.deleteAccountMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(c).pop(false);
            },
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(c).pop(true);
            },
            child: Text(l.deleteAccountConfirm),
          ),
        ],
      );
    },
  );
  if (r != true || !context.mounted) {
    return;
  }
  try {
    await ref.read(authRepositoryProvider).deleteAccount();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.deleteAccountSuccess)));
    }
  } on Object catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l.deleteAccountFailed}: $e')),
      );
    }
  }
}
