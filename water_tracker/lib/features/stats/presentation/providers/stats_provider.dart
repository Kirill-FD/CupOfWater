import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/settings/presentation/providers/settings_provider.dart';
import 'package:water_tracker/features/stats/data/stats_repository.dart';

part 'stats_provider.g.dart';

@riverpod
StatsRepository statsRepository(StatsRepositoryRef ref) {
  return StatsRepository(Supabase.instance.client);
}

@riverpod
Future<Map<DateTime, int>> weeklyStats(WeeklyStatsRef ref) async {
  final userProfile = await ref.watch(userProfileNotifierProvider.future);
  return ref
      .watch(statsRepositoryProvider)
      .getWeeklyStats(timezone: userProfile.timezone);
}

@riverpod
Future<Map<DateTime, int>> monthlyStats(MonthlyStatsRef ref) async {
  final userProfile = await ref.watch(userProfileNotifierProvider.future);
  return ref
      .watch(statsRepositoryProvider)
      .getMonthlyStats(timezone: userProfile.timezone);
}

@riverpod
Future<int> currentStreak(CurrentStreakRef ref) async {
  final userProfile = await ref.watch(userProfileNotifierProvider.future);
  return ref
      .read(statsRepositoryProvider)
      .getCurrentStreak(
        userProfile.dailyGoalMl,
        timezone: userProfile.timezone,
      );
}

@riverpod
Future<Map<DateTime, int>> calendarMonthStats(
  CalendarMonthStatsRef ref,
  int year,
  int month,
) async {
  final UserProfile userProfile =
      await ref.watch(userProfileNotifierProvider.future);
  return ref.read(statsRepositoryProvider).getCalendarMonthStats(
        year: year,
        month: month,
        timezone: userProfile.timezone,
      );
}

@riverpod
Future<Map<int, int>> yearlyMonthlyTotals(
  YearlyMonthlyTotalsRef ref,
  int year,
) async {
  final UserProfile userProfile =
      await ref.watch(userProfileNotifierProvider.future);
  return ref.read(statsRepositoryProvider).getMonthlyTotalsForYear(
        year: year,
        timezone: userProfile.timezone,
      );
}

/// Средние за текущую и предыдущую недели (7 дней).
@riverpod
Future<({double currentAvg, double previousAvg})> weekOverWeekAverages(
  WeekOverWeekAveragesRef ref,
) async {
  final UserProfile userProfile =
      await ref.watch(userProfileNotifierProvider.future);
  final StatsRepository repo = ref.read(statsRepositoryProvider);
  final DateTime today = DateTime.now();
  final DateTime endPrev =
      DateTime(today.year, today.month, today.day)
          .subtract(const Duration(days: 7));
  final Map<DateTime, int> cur =
      await repo.getWeeklyStats(timezone: userProfile.timezone);
  final Map<DateTime, int> prev = await repo.getWeekStatsEnding(
    endDay: endPrev,
    timezone: userProfile.timezone,
  );
  double avg(Map<DateTime, int> m) {
    if (m.isEmpty) {
      return 0;
    }
    final int s = m.values.fold<int>(0, (int a, int b) => a + b);
    return s / m.length;
  }

  return (currentAvg: avg(cur), previousAvg: avg(prev));
}

/// Сумма и дни с записью за последние ~365 дней (блок «профиль»).
@riverpod
Future<({int sumMl, int activeDays})> profileRollingYearStats(
  ProfileRollingYearStatsRef ref,
) async {
  final UserProfile userProfile =
      await ref.watch(userProfileNotifierProvider.future);
  final DateTime end = DateTime.now();
  final DateTime start = end.subtract(const Duration(days: 364));
  return ref.read(statsRepositoryProvider).getRangeTotals(
        start: DateTime(start.year, start.month, start.day),
        end: DateTime(end.year, end.month, end.day),
        timezone: userProfile.timezone,
      );
}
