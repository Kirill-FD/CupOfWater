import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;
import 'package:url_launcher/url_launcher.dart';
import 'package:water_tracker/core/providers/app_theme_mode_provider.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:water_tracker/shared/services/notification_service.dart';
import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/shared/widgets/shimmer_placeholder.dart';
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:water_tracker/features/settings/presentation/providers/settings_provider.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';

const List<int> kReminderIntervalOptions = <int>[30, 45, 60, 90, 120];

/// Замените ссылку на фактическую политику конфиденциальности.
final Uri kPrivacyUrl = Uri.parse('https://www.example.com/privacy');

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(currentUserProvider);
    final String email = user?.email ?? '—';
    final AppLocalizations l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.settings),
        automaticallyImplyLeading: false,
      ),
      body: ref.watch(userProfileNotifierProvider).when(
            data: (UserProfile p) {
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(userProfileNotifierProvider);
                  ref.invalidate(dailyWaterGoalProvider);
                  await ref.read(userProfileNotifierProvider.future);
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    _sectionTitle(context, l.profile),
                    ListTile(
                      title: Text(l.email),
                      subtitle: Text(email),
                    ),
                    ListTile(
                      title: Text(l.name),
                      subtitle: Text(
                        p.displayName?.isNotEmpty == true
                            ? p.displayName!
                            : l.notSet,
                      ),
                      trailing: const Icon(Icons.edit_outlined),
                      onTap: () {
                        unawaited(_showEditNameDialog(context, ref, p));
                      },
                    ),
                    const Divider(height: 1),
                    _sectionTitle(context, l.dailyGoal),
                    ListTile(
                      title: Text(l.dailyGoal),
                      subtitle: Text(l.mlFormat(p.dailyGoalMl)),
                      onTap: () {
                        unawaited(_showGoalDialog(context, ref, p));
                      },
                    ),
                    const Divider(height: 1),
                    _sectionTitle(context, l.reminders),
                    SwitchListTile(
                      title: Text(l.remindersLabel),
                      value: p.reminderEnabled,
                      onChanged: (bool v) {
                        unawaited(
                          ref
                              .read(userProfileNotifierProvider.notifier)
                              .updateReminders(
                                enabled: v,
                                intervalMinutes: p.reminderIntervalMinutes,
                                startTime: p.startTimeOfDay,
                                endTime: p.endTimeOfDay,
                              )
                              .then((void _) {})
                              .catchError(
                                (Object? e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l.remindersError(
                                            e?.toString() ?? '',
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                        );
                      },
                    ),
                    if (p.reminderEnabled) ...<Widget>[
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
                          MaterialLocalizations.of(context)
                              .formatTimeOfDay(p.startTimeOfDay),
                        ),
                        onTap: () {
                          unawaited(_pickTime(context, ref, p, isStart: true));
                        },
                      ),
                      ListTile(
                        title: Text(l.reminderTo),
                        subtitle: Text(
                          MaterialLocalizations.of(context)
                              .formatTimeOfDay(p.endTimeOfDay),
                        ),
                        onTap: () {
                          unawaited(
                            _pickTime(context, ref, p, isStart: false),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    const Divider(height: 1),
                    _sectionTitle(context, l.appearance),
                    ref.watch(appThemeModeProvider).when(
                      data: (ThemeMode m) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SegmentedButton<ThemeMode>(
                            segments: <ButtonSegment<ThemeMode>>[
                              ButtonSegment<ThemeMode>(
                                value: ThemeMode.system,
                                label: Text(l.themeSystem, maxLines: 1),
                                icon: const Icon(Icons.brightness_auto, size: 20),
                              ),
                              ButtonSegment<ThemeMode>(
                                value: ThemeMode.light,
                                label: Text(l.themeLight, maxLines: 1),
                                icon: const Icon(Icons.light_mode, size: 20),
                              ),
                              ButtonSegment<ThemeMode>(
                                value: ThemeMode.dark,
                                label: Text(l.themeDark, maxLines: 1),
                                icon: const Icon(Icons.dark_mode, size: 20),
                              ),
                            ],
                            selected: <ThemeMode>{m},
                            onSelectionChanged: (Set<ThemeMode> s) {
                              if (s.isNotEmpty) {
                                unawaited(
                                  ref
                                      .read(appThemeModeProvider.notifier)
                                      .setTheme(s.first),
                                );
                              }
                            },
                          ),
                        );
                      },
                      loading: () {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ShimmerListTileLine(),
                        );
                      },
                      error: (Object? _, Object? __) {
                        return ListTile(
                          title: Text(l.themeLoadError),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    _sectionTitle(context, l.account),
                    ListTile(
                      title: Text(
                        l.logout,
                        style: const TextStyle(color: AppColors.error),
                      ),
                      leading: const Icon(
                        Icons.logout,
                        color: AppColors.error,
                      ),
                      onTap: () {
                        unawaited(_showLogoutDialog(context, ref));
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
                      trailing: const Icon(Icons.open_in_new, size: 20),
                      onTap: () {
                        unawaited(_openPrivacy(context));
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
                    Text(
                      l.profileLoadError,
                      textAlign: TextAlign.center,
                    ),
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
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
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
                      _showWeightForGoal(
                        dContext,
                        (int newGoal) {
                          st(() {
                            goal = newGoal;
                          });
                        },
                      ),
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
                  unawaited(
                    ref
                        .read(userProfileNotifierProvider.notifier)
                        .updateGoal(goal)
                        .then(
                      (void _) {
                        if (dContext.mounted) {
                          ref.invalidate(dailyWaterGoalProvider);
                          Navigator.of(dContext).pop();
                        }
                      },
                    ).catchError(
                      (Object? e) {
                        if (dContext.mounted) {
                          Navigator.of(dContext).pop();
                        }
                        if (dContext.mounted) {
                          ScaffoldMessenger.of(dContext).showSnackBar(
                            SnackBar(
                              content: Text(l.errorGeneric(e.toString())),
                            ),
                          );
                        }
                      },
                    ),
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
  void Function(int goalMl) onGoalComputed,
) async {
  final AppLocalizations l = AppLocalizations.of(parentContext);
  String weightInput = '';
  final bool? done = await showDialog<bool>(
    context: parentContext,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(l.weightKg),
        content: TextFormField(
          initialValue: weightInput,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: l.weightExample,
          ),
          onChanged: (String value) {
            weightInput = value;
          },
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
    return;
  }
  final double? k = double.tryParse(
    weightInput.trim().replaceAll(',', '.'),
  );
  if (k == null) {
    return;
  }
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
                        .catchError(
                      (Object? e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l.errorGeneric(e.toString()),
                              ),
                            ),
                          );
                        }
                      },
                    ),
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
    await ref.read(userProfileNotifierProvider.notifier).updateReminders(
          enabled: p.reminderEnabled,
          intervalMinutes: p.reminderIntervalMinutes,
          startTime: picked,
          endTime: p.endTimeOfDay,
        );
  } else {
    await ref.read(userProfileNotifierProvider.notifier).updateReminders(
          enabled: p.reminderEnabled,
          intervalMinutes: p.reminderIntervalMinutes,
          startTime: p.startTimeOfDay,
          endTime: picked,
        );
  }
}

Future<void> _openPrivacy(BuildContext context) async {
  if (!context.mounted) {
    return;
  }
  final AppLocalizations l = AppLocalizations.of(context);
  final bool ok = await launchUrl(
    kPrivacyUrl,
    mode: LaunchMode.externalApplication,
  );
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.privacyOpenFailed),
      ),
    );
  }
}

Future<void> _showLogoutDialog(
  BuildContext context,
  WidgetRef ref,
) async {
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
            style: FilledButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.logoutFailed}: $e')),
        );
      }
    }
  }
}
