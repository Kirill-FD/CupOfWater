import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
