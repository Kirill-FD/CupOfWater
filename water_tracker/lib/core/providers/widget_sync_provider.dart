import 'dart:async' show unawaited;

import 'package:flutter_riverpod/flutter_riverpod.dart' show AsyncValue;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/settings/presentation/providers/settings_provider.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';
import 'package:water_tracker/shared/services/widget_service.dart';

part 'widget_sync_provider.g.dart';

@Riverpod(keepAlive: true)
int widgetSync(WidgetSyncRef ref) {
  ref.listen<int>(
    todayTotalProvider,
    (int? p, int next) {
      final int goal = ref
              .read(userProfileNotifierProvider)
              .valueOrNull
              ?.dailyGoalMl ??
          2000;
      unawaited(WidgetService.update(current: next, goal: goal));
    },
  );
  ref.listen<AsyncValue<UserProfile>>(
    userProfileNotifierProvider,
    (AsyncValue<UserProfile>? p, AsyncValue<UserProfile> n) {
      n.whenData(
        (UserProfile pr) {
          unawaited(
            WidgetService.update(
              current: ref.read(todayTotalProvider),
              goal: pr.dailyGoalMl,
            ),
          );
        },
      );
    },
  );
  ref.listen<AsyncValue<int>>(
    dailyWaterGoalProvider,
    (p, n) {
      n.whenData(
        (g) {
          unawaited(
            WidgetService.update(
              current: ref.read(todayTotalProvider),
              goal: g,
            ),
          );
        },
      );
    },
  );
  final int initialGoal = ref
          .read(userProfileNotifierProvider)
          .valueOrNull
          ?.dailyGoalMl ??
      ref.read(dailyWaterGoalProvider).valueOrNull ??
      2000;
  unawaited(
    WidgetService.update(
      current: ref.read(todayTotalProvider),
      goal: initialGoal,
    ),
  );
  return 0;
}
