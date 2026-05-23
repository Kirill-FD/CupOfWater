import 'dart:async' show unawaited;
import 'dart:math' show pi;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:water_tracker/core/providers/widget_sync_provider.dart';
import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/settings/presentation/providers/settings_provider.dart';
import 'package:water_tracker/features/stats/presentation/providers/stats_provider.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';
import 'package:water_tracker/features/water/presentation/widgets/intake_list_tile.dart';
import 'package:water_tracker/features/water/presentation/widgets/mini_week_bars.dart';
import 'package:water_tracker/features/water/presentation/widgets/volume_chip_button.dart';
import 'package:water_tracker/features/water/presentation/widgets/water_progress_circle.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:water_tracker/shared/services/notification_service.dart';
import 'package:water_tracker/shared/widgets/empty_state.dart';
import 'package:water_tracker/shared/widgets/shimmer_placeholder.dart';
import 'package:water_tracker/shared/widgets/water_drop_overlay.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ConfettiController _confetti = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  double _customMl = 300;
  int _selectedQuickMl = 250;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!context.mounted) {
        return;
      }
      unawaited(NotificationService.instance.requestPermissionsIfFirstTime());
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _onAdd(int amountMl) async {
    if (!mounted) {
      return;
    }
    HapticFeedback.mediumImpact();
    showWaterDropOverlay(Navigator.of(context));
    final AddIntakeResult r = await ref
        .read(todayIntakesProvider.notifier)
        .addIntake(amountMl);
    if (!mounted) {
      return;
    }
    final AppLocalizations l = AppLocalizations.of(context);
    if (r.queuedOffline) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.addWater)));
    }
    if (r.goalFirstHit) {
      HapticFeedback.heavyImpact();
      _confetti.play();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.goalReached)));
    }
    ref.invalidate(weeklyStatsProvider);
    ref.invalidate(currentStreakProvider);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    ref.watch(widgetSyncProvider);
    final String locale = Localizations.localeOf(context).toString();
    final DateTime today = DateTime.now();
    final String dateHead =
        '${l.homeTodayHeader}, ${DateFormat.MMMd(locale).format(today)}';

    final AsyncValue<UserProfile> profile = ref.watch(
      userProfileNotifierProvider,
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(todayIntakesProvider);
                ref.invalidate(dailyWaterGoalProvider);
                ref.invalidate(weeklyStatsProvider);
                ref.invalidate(currentStreakProvider);
                ref.invalidate(userProfileNotifierProvider);
                await ref.read(todayIntakesProvider.future);
                await ref.read(dailyWaterGoalProvider.future);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 108),
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          dateHead,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: theme.cardColor,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => context.go('/settings'),
                          child: Ink(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Center(
                              child: profile.maybeWhen(
                                data: (UserProfile p) {
                                  final String raw =
                                      (p.displayName?.trim().isNotEmpty == true)
                                      ? p.displayName!.trim()
                                      : '';
                                  final String letter = raw.isEmpty
                                      ? '?'
                                      : String.fromCharCode(
                                          raw.runes.first,
                                        ).toUpperCase();
                                  return Text(
                                    letter,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.primary,
                                    ),
                                  );
                                },
                                orElse: () => const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (BuildContext context) {
                      final int goal =
                          profile.valueOrNull?.dailyGoalMl ??
                          ref.watch(dailyWaterGoalProvider).valueOrNull ??
                          2000;
                      final int current = ref.watch(todayTotalProvider);
                      final int remaining = (goal - current).clamp(0, goal);

                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => unawaited(_onAdd(250)),
                            child: WaterProgressCircle(
                              current: current,
                              goal: goal,
                              size: 260,
                              animateWave: true,
                              centerSubLabel: l.intakeFromGoal(goal),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            remaining > 0
                                ? l.homeMlLeft(
                                    NumberFormat.decimalPattern(
                                      locale,
                                    ).format(remaining),
                                  )
                                : l.homeGoalDone,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.65,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 22),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _SectionLabel(text: l.homeQuickAdd),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              VolumeChipButton(
                                ml: 100,
                                icon: Icons.opacity_outlined,
                                active: _selectedQuickMl == 100,
                                onTap: () {
                                  setState(() => _selectedQuickMl = 100);
                                  unawaited(_onAdd(100));
                                },
                              ),
                              const SizedBox(width: 10),
                              VolumeChipButton(
                                ml: 200,
                                icon: Icons.local_drink_outlined,
                                active: _selectedQuickMl == 200,
                                onTap: () {
                                  setState(() => _selectedQuickMl = 200);
                                  unawaited(_onAdd(200));
                                },
                              ),
                              const SizedBox(width: 10),
                              VolumeChipButton(
                                ml: 250,
                                icon: Icons.local_cafe_outlined,
                                active: _selectedQuickMl == 250,
                                onTap: () {
                                  setState(() => _selectedQuickMl = 250);
                                  unawaited(_onAdd(250));
                                },
                              ),
                              const SizedBox(width: 10),
                              VolumeChipButton(
                                ml: 500,
                                icon: Icons.local_drink_outlined,
                                active: _selectedQuickMl == 500,
                                onTap: () {
                                  setState(() => _selectedQuickMl = 500);
                                  unawaited(_onAdd(500));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: theme.dividerColor.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            l.homeCustomVolume.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.04,
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.55),
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: _customMl
                                                      .round()
                                                      .toString(),
                                                  style: theme
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text: ' ${l.mlUnit}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: theme
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(
                                                          alpha: 0.55,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: AppColors.primary,
                                          inactiveTrackColor: theme.dividerColor
                                              .withValues(alpha: 0.6),
                                          thumbColor: Colors.white,
                                          overlayColor: AppColors.primary
                                              .withValues(alpha: 0.15),
                                          trackHeight: 6,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                enabledThumbRadius: 9,
                                              ),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                                overlayRadius: 18,
                                              ),
                                        ),
                                        child: Slider(
                                          value: _customMl.clamp(0, 1000),
                                          min: 0,
                                          max: 1000,
                                          divisions: 100,
                                          onChanged: (double v) {
                                            setState(() {
                                              _customMl =
                                                  (v / 10).round() * 10.0;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: _customMl <= 0
                                        ? null
                                        : AppColors.waterGradient,
                                    borderRadius: BorderRadius.circular(14),
                                    color: _customMl <= 0
                                        ? theme.dividerColor
                                        : null,
                                    boxShadow: _customMl <= 0
                                        ? null
                                        : <BoxShadow>[
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.35),
                                              blurRadius: 18,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                  ),
                                  child: SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(14),
                                        onTap: _customMl <= 0
                                            ? null
                                            : () => unawaited(
                                                _onAdd(_customMl.round()),
                                              ),
                                        child: Icon(
                                          Icons.add,
                                          color: _customMl <= 0
                                              ? theme.disabledColor
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: <Widget>[
                              Expanded(child: _StreakCard()),
                              const SizedBox(width: 10),
                              Expanded(child: _WeekMiniCard(goal: goal)),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l.todayHistory,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _TodayIntakesSection(onAdd: _onAdd),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 20,
              minBlastForce: 8,
              numberOfParticles: 18,
              shouldLoop: false,
              colors: const <Color>[
                AppColors.primary,
                AppColors.accent,
                AppColors.success,
                Colors.amber,
              ],
              blastDirection: -pi / 2,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.06,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
      ),
    );
  }
}

class _StreakCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<int> streak = ref.watch(currentStreakProvider);
    final int value = streak.valueOrNull ?? 0;
    return _ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.bolt_outlined,
                size: 18,
                color: Colors.deepOrange.shade400,
              ),
              const SizedBox(width: 6),
              Text(
                l.streak,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: '$value ',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: l.homeStreakSubtitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          if (streak.isLoading && streak.hasValue) ...<Widget>[
            const SizedBox(height: 8),
            const LinearProgressIndicator(minHeight: 2),
          ],
        ],
      ),
    );
  }
}

class _WeekMiniCard extends ConsumerWidget {
  const _WeekMiniCard({required this.goal});

  final int goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<Map<DateTime, int>> week = ref.watch(weeklyStatsProvider);
    final Map<DateTime, int> data = _withTodayTotal(
      week.valueOrNull ?? _emptyCurrentWeek(),
      ref.watch(todayTotalProvider),
    );

    return _ElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.bar_chart_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l.homeWeekMini,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          MiniWeekBars(
            valuesMl: _sortedWeekValues(data),
            goalMl: goal <= 0 ? 2000 : goal,
            todayIndex: 6,
          ),
          if (week.isLoading && week.hasValue) ...<Widget>[
            const SizedBox(height: 8),
            const LinearProgressIndicator(minHeight: 2),
          ],
        ],
      ),
    );
  }

  Map<DateTime, int> _emptyCurrentWeek() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return <DateTime, int>{
      for (int i = 6; i >= 0; i--) today.subtract(Duration(days: i)): 0,
    };
  }

  List<int> _sortedWeekValues(Map<DateTime, int> data) {
    final List<DateTime> days = data.keys.toList()..sort();
    return days.map((DateTime d) => data[d] ?? 0).toList();
  }

  Map<DateTime, int> _withTodayTotal(Map<DateTime, int> raw, int todayTotal) {
    if (todayTotal <= 0) {
      return raw;
    }
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return <DateTime, int>{
      ...raw,
      today: raw[today] != null && raw[today]! > todayTotal
          ? raw[today]!
          : todayTotal,
    };
  }
}

class _ElevatedCard extends StatelessWidget {
  const _ElevatedCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: child,
    );
  }
}

class _TodayIntakesSection extends ConsumerWidget {
  const _TodayIntakesSection({required this.onAdd});

  final Future<void> Function(int amountMl) onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<WaterIntake>> intakes = ref.watch(
      todayIntakesProvider,
    );
    final AppLocalizations l = AppLocalizations.of(context);
    return intakes.when(
      data: (List<WaterIntake> list) {
        if (list.isEmpty) {
          return AppEmptyState(
            message: l.addFirstIntake,
            actionLabel: l.emptyCta,
            onAction: () {
              unawaited(onAdd(250));
            },
          );
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            return IntakeListTile(intake: list[i]);
          },
        );
      },
      loading: () {
        final List<WaterIntake>? list = intakes.valueOrNull;
        if (list != null && list.isNotEmpty) {
          return _IntakeList(list: list);
        }
        return const ShimmerListPlaceholder();
      },
      error: (Object e, StackTrace s) {
        return AppEmptyState(
          message: l.addFirstIntake,
          actionLabel: l.retry,
          onAction: () {
            ref.invalidate(todayIntakesProvider);
          },
        );
      },
    );
  }
}

class _IntakeList extends StatelessWidget {
  const _IntakeList({required this.list});

  final List<WaterIntake> list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        return IntakeListTile(intake: list[i]);
      },
    );
  }
}
