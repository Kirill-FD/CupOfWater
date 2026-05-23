import 'dart:async' show unawaited;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/settings/presentation/providers/settings_provider.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';
import 'package:water_tracker/shared/services/widget_service.dart';

part 'widget_sync_provider.g.dart';

@Riverpod(keepAlive: true)
int widgetSync(WidgetSyncRef ref) {
  int sumIntakes(List<WaterIntake> intakes) {
    return intakes.fold<int>(0, (int sum, WaterIntake i) => sum + i.amountMl);
  }

  Future<void> updateWidget({int? current, int? goal}) async {
    final int resolvedCurrent =
        current ?? await WidgetService.readCurrentTotal() ?? 0;
    final int resolvedGoal =
        goal ??
        ref.read(userProfileNotifierProvider).valueOrNull?.dailyGoalMl ??
        2000;
    await WidgetService.update(current: resolvedCurrent, goal: resolvedGoal);
  }

  ref.listen<AsyncValue<List<WaterIntake>>>(todayIntakesProvider, (
    AsyncValue<List<WaterIntake>>? p,
    AsyncValue<List<WaterIntake>> next,
  ) {
    next.whenData((List<WaterIntake> intakes) {
      unawaited(updateWidget(current: sumIntakes(intakes)));
    });
  });
  ref.listen<AsyncValue<UserProfile>>(userProfileNotifierProvider, (
    AsyncValue<UserProfile>? p,
    AsyncValue<UserProfile> n,
  ) {
    n.whenData((UserProfile pr) {
      unawaited(updateWidget(goal: pr.dailyGoalMl));
    });
  });
  ref.read(todayIntakesProvider).whenData((List<WaterIntake> intakes) {
    unawaited(updateWidget(current: sumIntakes(intakes)));
  });
  return 0;
}
