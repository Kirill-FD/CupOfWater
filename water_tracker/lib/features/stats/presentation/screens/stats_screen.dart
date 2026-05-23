import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/settings/presentation/providers/settings_provider.dart';
import 'package:water_tracker/features/stats/presentation/providers/stats_provider.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';
import 'package:water_tracker/l10n/app_localizations.dart';

/// Статистика: неделя / месяц (календарь).
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _period = 0;
  int _monthOffset = 0;

  DateTime get _visibleMonth {
    final DateTime n = DateTime.now();
    return DateTime(n.year, n.month + _monthOffset, 1);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.statsTitle),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _PeriodSwitcher(
              period: _period,
              onChanged: (int i) => setState(() => _period = i),
              labels: <String>[l.statsPeriodWeek, l.statsPeriodMonth],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _period == 0
                    ? KeyedSubtree(
                        key: const ValueKey<String>('week'),
                        child: _WeekStatsPane(
                          onRefresh: () async {
                            ref.invalidate(weeklyStatsProvider);
                            ref.invalidate(weekOverWeekAveragesProvider);
                            ref.invalidate(currentStreakProvider);
                            ref.invalidate(dailyWaterGoalProvider);
                          },
                        ),
                      )
                    : KeyedSubtree(
                        key: const ValueKey<String>('month'),
                        child: _MonthCalendarPane(
                          visibleMonth: _visibleMonth,
                          onPrev: () => setState(() => _monthOffset--),
                          onNext: () => setState(() => _monthOffset++),
                          onRefresh: () async {
                            final DateTime v = _visibleMonth;
                            ref.invalidate(
                              calendarMonthStatsProvider(v.year, v.month),
                            );
                            ref.invalidate(dailyWaterGoalProvider);
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodSwitcher extends StatelessWidget {
  const _PeriodSwitcher({
    required this.period,
    required this.onChanged,
    required this.labels,
  });

  final int period;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: List<Widget>.generate(labels.length, (int i) {
          final bool sel = i == period;
          return Expanded(
            child: Material(
              color: sel ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              child: InkWell(
                borderRadius: BorderRadius.circular(9),
                onTap: () => onChanged(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: sel
                          ? Colors.white
                          : theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _WeekStatsPane extends ConsumerWidget {
  const _WeekStatsPane({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final String locale = Localizations.localeOf(context).toString();
    final ThemeData theme = Theme.of(context);
    final bool dark = theme.brightness == Brightness.dark;

    final AsyncValue<Map<DateTime, int>> week = ref.watch(weeklyStatsProvider);
    final AsyncValue<int> streak = ref.watch(currentStreakProvider);
    final AsyncValue<({double currentAvg, double previousAvg})> wow = ref.watch(
      weekOverWeekAveragesProvider,
    );
    final int todayTotal = ref.watch(todayTotalProvider);
    final Map<DateTime, int> data = _withTodayTotal(
      week.valueOrNull ?? _emptyWeek(DateTime.now()),
      todayTotal,
    );
    final UserProfile? profile = ref
        .watch(userProfileNotifierProvider)
        .valueOrNull;
    final int goal =
        profile?.dailyGoalMl ??
        ref.watch(dailyWaterGoalProvider).valueOrNull ??
        2000;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Builder(
        builder: (BuildContext context) {
          final List<DateTime> days = data.keys.toList()..sort();
          final List<int> vals = days
              .map((DateTime d) => data[d] ?? 0)
              .toList();
          final int sum = vals.fold<int>(0, (int a, int b) => a + b);
          final double avg = vals.isEmpty ? 0 : sum / vals.length;
          final int daysMet = vals.where((int v) => v >= goal).length;
          int bestIdx = 0;
          for (int i = 1; i < vals.length; i++) {
            if (vals[i] > vals[bestIdx]) {
              bestIdx = i;
            }
          }
          final int bestMl = vals.isEmpty ? 0 : vals[bestIdx];
          final String bestDay = days.isEmpty
              ? '—'
              : DateFormat.E(locale).format(days[bestIdx]);
          final double totalLiters = sum / 1000;

          final String wowText = wow.maybeWhen(
            data: (({double currentAvg, double previousAvg}) v) {
              if (v.previousAvg <= 1e-6) {
                return '';
              }
              final int pct =
                  ((v.currentAvg - v.previousAvg) / v.previousAvg * 100)
                      .round()
                      .abs();
              if (v.currentAvg >= v.previousAvg) {
                return l.statsVsLastWeek(pct);
              }
              return l.statsVsLastWeekDown(pct);
            },
            orElse: () => '',
          );

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Text(
                l.statsAvgWeek,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    NumberFormat.decimalPattern(locale).format(avg.round()),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l.statsMlPerDaySuffix,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.55,
                      ),
                    ),
                  ),
                ],
              ),
              if (wowText.isNotEmpty) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  wowText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              _Card(
                child: SizedBox(
                  height: 182,
                  child: _WeekColumnChart(
                    days: days,
                    valuesMl: vals,
                    goal: goal,
                    locale: locale,
                    dark: dark,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _SmallMetricCard(
                      title: l.statsDaysGoalTitle,
                      value: l.statsDaysGoalValue(daysMet, days.length),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SmallMetricCard(
                      title: l.statsBestDayTitle,
                      value:
                          '${NumberFormat.decimalPattern(locale).format(bestMl / 1000)} · $bestDay',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: streak.when(
                      data: (int s) => _SmallMetricCard(
                        title: l.streakLabel,
                        value: '$s ${l.homeStreakSubtitle}',
                        valueColor: const Color(0xFFFF8A3D),
                      ),
                      loading: () => _SmallMetricCard(
                        title: l.streakLabel,
                        value: '0 ${l.homeStreakSubtitle}',
                        valueColor: const Color(0xFFFF8A3D),
                      ),
                      error: (Object _, StackTrace __) => _SmallMetricCard(
                        title: l.streakLabel,
                        value: '0 ${l.homeStreakSubtitle}',
                        valueColor: const Color(0xFFFF8A3D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SmallMetricCard(
                      title: l.statsTotalWeekTitle,
                      value: l.statsLitersShort(
                        NumberFormat.decimalPattern(
                          locale,
                        ).format(double.parse(totalLiters.toStringAsFixed(1))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Map<DateTime, int> _emptyWeek(DateTime anchor) {
    final DateTime today = DateTime(anchor.year, anchor.month, anchor.day);
    return <DateTime, int>{
      for (int i = 6; i >= 0; i--) today.subtract(Duration(days: i)): 0,
    };
  }

  Map<DateTime, int> _withTodayTotal(Map<DateTime, int> raw, int todayTotal) {
    if (todayTotal <= 0) {
      return raw;
    }
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return <DateTime, int>{
      ...raw,
      today: math.max(raw[today] ?? 0, todayTotal),
    };
  }
}

class _WeekColumnChart extends StatelessWidget {
  const _WeekColumnChart({
    required this.days,
    required this.valuesMl,
    required this.goal,
    required this.locale,
    required this.dark,
  });

  final List<DateTime> days;
  final List<int> valuesMl;
  final int goal;
  final String locale;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty || valuesMl.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context).noData));
    }
    final int maxMl = math.max(goal, valuesMl.reduce(math.max));
    final double maxY = (maxMl * 1.15).ceilToDouble();
    const double chartH = 132;
    final DateTime today = DateTime.now();
    final DateTime todayDay = DateTime(today.year, today.month, today.day);

    final double goalY = chartH - (goal / maxY) * chartH;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              top: chartH - goalY,
              child: CustomPaint(
                size: Size(c.maxWidth, 1),
                painter: _DashedLinePainter(
                  color: AppColors.primary.withValues(alpha: 0.45),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: chartH - goalY - 18,
              child: Text(
                AppLocalizations.of(context).statsGoalLine(
                  NumberFormat.decimalPattern(locale).format(goal),
                ),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List<Widget>.generate(days.length, (int i) {
                  final int ml = valuesMl[i];
                  final double h = maxY <= 0 ? 0 : (ml / maxY) * chartH;
                  final bool isToday =
                      DateTime(days[i].year, days[i].month, days[i].day) ==
                      todayDay;
                  final bool reached = ml >= goal;
                  final Gradient? g = isToday ? AppColors.waterGradient : null;
                  final Color solid = reached
                      ? (dark
                            ? AppColors.primaryLight.withValues(alpha: 0.65)
                            : AppColors.primary.withValues(alpha: 0.85))
                      : AppColors.primary.withValues(alpha: dark ? 0.35 : 0.45);

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          if (isToday)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                NumberFormat.decimalPattern(locale).format(ml),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          Container(
                            height: h.clamp(4, chartH),
                            decoration: BoxDecoration(
                              gradient: g,
                              color: g == null ? solid : null,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                                bottom: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat.E(locale).format(days[i]),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isToday
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isToday
                                  ? AppColors.primary
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double dash = 4;
    const double gap = 4;
    double x = 0;
    final Paint p = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(math.min(x + dash, size.width), 0),
        p,
      );
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MonthCalendarPane extends ConsumerWidget {
  const _MonthCalendarPane({
    required this.visibleMonth,
    required this.onPrev,
    required this.onNext,
    required this.onRefresh,
  });

  final DateTime visibleMonth;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final String locale = Localizations.localeOf(context).toString();
    final int y = visibleMonth.year;
    final int m = visibleMonth.month;

    final AsyncValue<Map<DateTime, int>> stats = ref.watch(
      calendarMonthStatsProvider(y, m),
    );
    final int todayTotal = ref.watch(todayTotalProvider);
    final Map<DateTime, int> map = _withTodayTotal(
      stats.valueOrNull ?? <DateTime, int>{},
      todayTotal,
    );
    final UserProfile? profile = ref
        .watch(userProfileNotifierProvider)
        .valueOrNull;
    final int goal =
        profile?.dailyGoalMl ??
        ref.watch(dailyWaterGoalProvider).valueOrNull ??
        2000;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Builder(
        builder: (BuildContext context) {
          final DateTime first = DateTime(y, m, 1);
          final int daysInMonth = DateTime(y, m + 1, 0).day;
          final int pad = first.weekday - 1;
          final List<DateTime?> cells = <DateTime?>[
            ...List<DateTime?>.filled(pad, null),
            ...List<DateTime>.generate(
              daysInMonth,
              (int i) => DateTime(y, m, i + 1),
            ),
          ];

          int met = 0;
          for (int d = 1; d <= daysInMonth; d++) {
            final int v = map[DateTime(y, m, d)] ?? 0;
            if (v >= goal && goal > 0) {
              met++;
            }
          }
          final int sum = map.values.fold<int>(0, (int a, int b) => a + b);
          final double avgDay = daysInMonth > 0 ? sum / daysInMonth : 0;

          final DateTime today = DateTime.now();
          final DateTime todayD = DateTime(today.year, today.month, today.day);

          Color cellColor(double ratio, ThemeData t, bool darkMode) {
            if (ratio <= 0) {
              return t.cardColor;
            }
            if (ratio < 0.5) {
              return AppColors.primary.withValues(
                alpha: darkMode ? 0.18 : 0.16,
              );
            }
            if (ratio < 0.8) {
              return AppColors.primary.withValues(
                alpha: darkMode ? 0.36 : 0.36,
              );
            }
            if (ratio < 1.0) {
              return AppColors.primary.withValues(alpha: darkMode ? 0.6 : 0.6);
            }
            return AppColors.primary;
          }

          final bool dark = theme.brightness == Brightness.dark;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: onPrev,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      DateFormat.yMMMM(locale).format(first),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onNext,
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: List<Widget>.generate(7, (int i) {
                        final DateTime dummy = DateTime(2023, 1, 2 + i);
                        final String letter = DateFormat.E(
                          locale,
                        ).format(dummy)[0];
                        return Expanded(
                          child: Text(
                            letter,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.55,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 6,
                            crossAxisSpacing: 6,
                            childAspectRatio: 1,
                          ),
                      itemCount: cells.length,
                      itemBuilder: (BuildContext context, int i) {
                        final DateTime? day = cells[i];
                        if (day == null) {
                          return const SizedBox.shrink();
                        }
                        final int ml = map[day] ?? 0;
                        final double ratio = goal <= 0
                            ? 0
                            : ml / goal.toDouble();
                        final bool isToday = day == todayD;
                        final Color fg = ratio >= 0.8 && ratio > 0
                            ? Colors.white
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.65,
                              );
                        return Container(
                          decoration: BoxDecoration(
                            color: cellColor(ratio, theme, dark),
                            borderRadius: BorderRadius.circular(9),
                            border: isToday
                                ? Border.all(color: AppColors.primary, width: 2)
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: fg,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        Text(
                          l.statsHeatmapLess,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.55,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        ...<double>[0.2, 0.5, 0.8, 1.0].map(
                          (double r) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: cellColor(r, theme, dark),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l.statsHeatmapMore,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _SmallMetricCard(
                      title: l.statsMonthGoalsTitle,
                      value: l.statsMonthGoalsValue(met, daysInMonth),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SmallMetricCard(
                      title: l.statsMonthAvgTitle,
                      value: l.statsLitersPerDay(
                        NumberFormat.decimalPattern(locale).format(
                          double.parse((avgDay / 1000).toStringAsFixed(1)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Map<DateTime, int> _withTodayTotal(Map<DateTime, int> raw, int todayTotal) {
    if (todayTotal <= 0) {
      return raw;
    }
    final DateTime now = DateTime.now();
    if (now.year != visibleMonth.year || now.month != visibleMonth.month) {
      return raw;
    }
    final DateTime today = DateTime(now.year, now.month, now.day);
    return <DateTime, int>{
      ...raw,
      today: math.max(raw[today] ?? 0, todayTotal),
    };
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
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

class _SmallMetricCard extends StatelessWidget {
  const _SmallMetricCard({
    required this.title,
    required this.value,
    this.valueColor,
  });

  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.05,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
