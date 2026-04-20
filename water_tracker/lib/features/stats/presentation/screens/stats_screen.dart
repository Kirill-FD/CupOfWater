import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/features/stats/presentation/providers/stats_provider.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:water_tracker/shared/widgets/shimmer_placeholder.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.statsTitle),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: l.weeklyStats),
              Tab(text: l.monthlyStats),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            WeeklyStatsView(),
            MonthlyStatsView(),
          ],
        ),
      ),
    );
  }
}

class WeeklyStatsView extends ConsumerWidget {
  const WeeklyStatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Map<DateTime, int>> week = ref.watch(weeklyStatsProvider);
    final String locale = Localizations.localeOf(context).toString();
    return week.when(
      data: (Map<DateTime, int> data) {
        return ref.watch(dailyWaterGoalProvider).when(
              data: (int goal) {
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(weeklyStatsProvider);
                    ref.invalidate(dailyWaterGoalProvider);
                    ref.invalidate(currentStreakProvider);
                    await ref.read(weeklyStatsProvider.future);
                  },
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      _SummaryCards(
                        data: data,
                        goal: goal,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 300,
                        child: _BarChartBlock(
                          sortedDays: data.keys.toList(),
                          values: data,
                          goal: goal,
                          bottomTitleBuilder: (int i, List<DateTime> days) {
                            if (i < 0 || i >= days.length) {
                              return '';
                            }
                            return DateFormat.E(locale).format(days[i]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () {
                return const _ShimmerStatsLoader();
              },
              error: (Object e, StackTrace s) {
                return _ErrorState(message: e.toString());
              },
            );
      },
      loading: () {
        return const _ShimmerStatsLoader();
      },
      error: (Object e, StackTrace s) {
        return _ErrorState(message: e.toString());
      },
    );
  }
}

class MonthlyStatsView extends ConsumerWidget {
  const MonthlyStatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Map<DateTime, int>> month = ref.watch(monthlyStatsProvider);
    final String locale = Localizations.localeOf(context).toString();
    return month.when(
      data: (Map<DateTime, int> data) {
        return ref.watch(dailyWaterGoalProvider).when(
              data: (int goal) {
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(monthlyStatsProvider);
                    ref.invalidate(dailyWaterGoalProvider);
                    ref.invalidate(currentStreakProvider);
                    await ref.read(monthlyStatsProvider.future);
                  },
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      _SummaryCards(
                        data: data,
                        goal: goal,
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          height: 300,
                          width: math
                              .max(320, data.length * 12.0 + 48)
                              .toDouble(),
                          child: _BarChartBlock(
                            sortedDays: data.keys.toList(),
                            values: data,
                            goal: goal,
                            bottomTitleBuilder: (int i, List<DateTime> days) {
                              if (i < 0 || i >= days.length) {
                                return '';
                              }
                              if (i % 3 != 0 && i != days.length - 1) {
                                return '';
                              }
                              return DateFormat('d MMM', locale)
                                  .format(days[i]);
                            },
                            groupsSpace: 1,
                            barWidth: 5,
                            rotateBottomTitles: -45,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () {
                return const _ShimmerStatsLoader();
              },
              error: (Object e, StackTrace s) {
                return _ErrorState(message: e.toString());
              },
            );
      },
      loading: () {
        return const _ShimmerStatsLoader();
      },
      error: (Object e, StackTrace s) {
        return _ErrorState(message: e.toString());
      },
    );
  }
}

class _ShimmerStatsLoader extends StatelessWidget {
  const _ShimmerStatsLoader();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: <Widget>[
        const ShimmerListTileLine(),
        const SizedBox(height: 12),
        const ShimmerListTileLine(),
        const SizedBox(height: 20),
        const ShimmerChartBox(),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _SummaryCards extends ConsumerWidget {
  const _SummaryCards({
    required this.data,
    required this.goal,
  });

  final Map<DateTime, int> data;
  final int goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    final int sum = data.values.fold<int>(0, (int a, int b) => a + b);
    final double average = data.isEmpty ? 0 : sum / data.length;
    final int daysMet = data.values
        .where((int v) => v >= goal)
        .length;

    final AsyncValue<int> streakAsync = ref.watch(currentStreakProvider);
    return streakAsync.when(
      data: (int streak) {
        return Row(
          children: <Widget>[
            Expanded(
              child: _InfoCard(
                label: l.averagePerDay,
                value: l.mlFormat(average.round()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoCard(
                label: l.daysGoalMet,
                value: '$daysMet',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoCard(
                label: l.streakLabel,
                value: '$streak',
              ),
            ),
          ],
        );
      },
      loading: () {
        return Row(
          children: <Widget>[
            Expanded(
              child: _InfoCard(
                label: l.averagePerDay,
                value: '—',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoCard(
                label: l.daysGoalMet,
                value: '—',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoCard(
                label: l.streakLabel,
                value: '…',
              ),
            ),
          ],
        );
      },
      error: (Object e, StackTrace s) {
        return Row(
          children: <Widget>[
            Expanded(
              child: _InfoCard(
                label: l.averagePerDay,
                value: l.mlFormat(average.round()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoCard(
                label: l.daysGoalMet,
                value: '$daysMet',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoCard(
                label: l.streakLabel,
                value: '—',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.labelSmall,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarChartBlock extends StatelessWidget {
  const _BarChartBlock({
    required this.sortedDays,
    required this.values,
    required this.goal,
    required this.bottomTitleBuilder,
    this.groupsSpace = 8,
    this.barWidth = 14,
    this.rotateBottomTitles = 0,
  });

  final List<DateTime> sortedDays;
  final Map<DateTime, int> values;
  final int goal;
  final String Function(int index, List<DateTime> days) bottomTitleBuilder;
  final double groupsSpace;
  final double barWidth;
  final double rotateBottomTitles;

  @override
  Widget build(BuildContext context) {
    final List<DateTime> days = <DateTime>[...sortedDays]..sort();
    if (days.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context).noData));
    }
    final List<int> yVals =
        days.map((DateTime d) => values[d] ?? 0).toList();
    final int maxVal = yVals.isEmpty
        ? goal
        : math.max(goal, yVals.reduce(math.max));
    final double maxY = (maxVal * 1.15).ceilToDouble();
    if (maxY == 0) {
      return Center(child: Text(AppLocalizations.of(context).noData));
    }
    const Color ok = AppColors.success;
    const Color low = AppColors.primary;

    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color grid = dark ? Colors.white24 : Colors.black26;
    final Color line = AppColors.accent;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          minY: 0,
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                final int i = group.x.toInt();
                if (i < 0 || i >= days.length) {
                  return null;
                }
                final int ml = yVals[i];
                return BarTooltipItem(
                  '$ml мл',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: <HorizontalLine>[
              HorizontalLine(
                y: goal.toDouble(),
                color: line,
                strokeWidth: 1.5,
                dashArray: <int>[4, 4],
                label: HorizontalLineLabel(
                  show: true,
                  style: TextStyle(
                    color: line,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  labelResolver: (HorizontalLine h) {
                    return '${goal} мл';
                  },
                ),
              ),
            ],
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: maxY / 4,
                getTitlesWidget: (double v, TitleMeta m) {
                  if (v > maxY) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    '${v.round()}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double v, TitleMeta m) {
                  final int i = v.toInt();
                  final String t = bottomTitleBuilder(i, days);
                  if (t.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Transform.rotate(
                      angle: rotateBottomTitles * math.pi / 180,
                      child: Text(
                        t,
                        style: const TextStyle(fontSize: 9),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: grid),
              bottom: BorderSide(color: grid),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (double v) {
              return FlLine(
                color: grid.withOpacity(0.4),
                strokeWidth: 1,
              );
            },
          ),
          barGroups: List<BarChartGroupData>.generate(
            days.length,
            (int i) {
              final int ml = yVals[i];
              return BarChartGroupData(
                x: i,
                barRods: <BarChartRodData>[
                  BarChartRodData(
                    toY: ml.toDouble(),
                    color: ml >= goal ? ok : low,
                    width: barWidth,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
          groupsSpace: groupsSpace,
        ),
        swapAnimationDuration: Duration.zero,
      ),
    );
  }
}
