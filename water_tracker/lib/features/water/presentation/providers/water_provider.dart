import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/core/providers/connectivity_state_provider.dart';
import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:water_tracker/features/water/data/water_repository.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/shared/services/offline_queue.dart';

part 'water_provider.g.dart';

class AddIntakeResult {
  const AddIntakeResult({
    this.goalFirstHit = false,
    this.queuedOffline = false,
  });

  final bool goalFirstHit;
  final bool queuedOffline;
}

@riverpod
WaterRepository waterRepository(WaterRepositoryRef ref) {
  return WaterRepository(Supabase.instance.client);
}

@riverpod
class TodayIntakes extends _$TodayIntakes {
  @override
  Future<List<WaterIntake>> build() async {
    final WaterRepository repo = ref.watch(waterRepositoryProvider);
    return repo.getTodayIntakes();
  }

  int _sumNonTemp(List<WaterIntake>? list) {
    return (list ?? <WaterIntake>[])
        .where((WaterIntake i) => !i.id.startsWith('temp-'))
        .fold<int>(0, (int a, WaterIntake b) => a + b.amountMl);
  }

  /// Добавление воды. При offline — [OfflineQueue], optimistic UI.
  Future<AddIntakeResult> addIntake(int amountMl) async {
    final String? uid = ref.read(currentUserProvider)?.id;
    if (uid == null) {
      return const AddIntakeResult();
    }
    final int goal = await ref.read(dailyWaterGoalProvider.future);
    final int before = _sumNonTemp(state.valueOrNull);
    final bool wouldHit = before < goal && before + amountMl >= goal;

    final String tempId = 'temp-${DateTime.now().millisecondsSinceEpoch}';
    final DateTime now = DateTime.now();
    final WaterIntake optimistic = WaterIntake(
      id: tempId,
      userId: uid,
      amountMl: amountMl,
      consumedAt: now,
      createdAt: now,
    );
    state = AsyncData<List<WaterIntake>>(
      <WaterIntake>[
        optimistic,
        ...?state.valueOrNull,
      ],
    );

    final bool online = await ref.read(isOnlineNowProvider.future);
    if (!online) {
      final OfflineQueue q = await OfflineQueue.instance;
      await q.enqueueAddIntake(amountMl);
      return AddIntakeResult(queuedOffline: true, goalFirstHit: false);
    }

    final WaterRepository repo = ref.read(waterRepositoryProvider);
    try {
      await repo.addIntake(amountMl);
      ref.invalidateSelf();
      return AddIntakeResult(
        goalFirstHit: wouldHit,
        queuedOffline: false,
      );
    } on Object {
      state = AsyncData<List<WaterIntake>>(
        (state.valueOrNull ?? <WaterIntake>[])
            .where((WaterIntake i) => i.id != tempId)
            .toList(),
      );
      rethrow;
    }
  }

  Future<void> deleteIntake(String id) async {
    final WaterRepository repo = ref.read(waterRepositoryProvider);
    state = AsyncData<List<WaterIntake>>(
      (state.valueOrNull ?? <WaterIntake>[])
          .where((WaterIntake i) => i.id != id)
          .toList(),
    );
    try {
      await repo.deleteIntake(id);
    } on Object {
      ref.invalidateSelf();
      rethrow;
    }
  }
}

@riverpod
int todayTotal(TodayTotalRef ref) {
  final List<WaterIntake> intakes = ref
          .watch(todayIntakesProvider)
          .valueOrNull ??
      <WaterIntake>[];
  return intakes.fold<int>(0, (int sum, WaterIntake i) => sum + i.amountMl);
}

@riverpod
Future<int> dailyWaterGoal(DailyWaterGoalRef ref) async {
  final String? uid = Supabase.instance.client.auth.currentUser?.id;
  if (uid == null) {
    return 2000;
  }
  final Map<String, dynamic>? row = await Supabase.instance.client
      .from('profiles')
      .select('daily_goal_ml')
      .eq('id', uid)
      .maybeSingle();
  if (row == null) {
    return 2000;
  }
  return (row['daily_goal_ml'] as num?)?.toInt() ?? 2000;
}
