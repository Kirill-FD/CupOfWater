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
  return ref.watch(statsRepositoryProvider).getWeeklyStats();
}

@riverpod
Future<Map<DateTime, int>> monthlyStats(MonthlyStatsRef ref) async {
  return ref.watch(statsRepositoryProvider).getMonthlyStats();
}

@riverpod
Future<int> currentStreak(CurrentStreakRef ref) async {
  final userProfile = await ref.watch(userProfileNotifierProvider.future);
  return ref
      .read(statsRepositoryProvider)
      .getCurrentStreak(userProfile.dailyGoalMl);
}
