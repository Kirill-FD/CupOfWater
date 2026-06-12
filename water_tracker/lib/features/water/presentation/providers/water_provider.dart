import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/core/providers/connectivity_state_provider.dart';
import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:water_tracker/features/water/data/water_repository.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/shared/services/offline_queue.dart';
import 'package:water_tracker/shared/services/widget_service.dart';

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
    final User? user = ref.watch(currentUserProvider);
    if (user == null) {
      return <WaterIntake>[];
    }
    final WaterRepository repo = ref.watch(waterRepositoryProvider);
    try {
      return await repo.getTodayIntakes();
    } on Object {
      return _withWidgetSnapshotFallback(
        intakes: state.valueOrNull ?? <WaterIntake>[],
        userId: user.id,
      );
    }
  }

  Future<void> refreshFromServerPreservingState() async {
    final User? user = ref.read(currentUserProvider);
    if (user == null) {
      state = const AsyncData<List<WaterIntake>>(<WaterIntake>[]);
      return;
    }
    final List<WaterIntake> previous = state.valueOrNull ?? <WaterIntake>[];
    try {
      final List<WaterIntake> intakes = await ref
          .read(waterRepositoryProvider)
          .getTodayIntakes();
      state = AsyncData<List<WaterIntake>>(intakes);
    } on Object {
      state = AsyncData<List<WaterIntake>>(
        await _withWidgetSnapshotFallback(intakes: previous, userId: user.id),
      );
    }
  }

  int _sumNonTemp(List<WaterIntake>? list) {
    return (list ?? <WaterIntake>[])
        .where((WaterIntake i) => !i.id.startsWith('temp-'))
        .fold<int>(0, (int a, WaterIntake b) => a + b.amountMl);
  }

  int _sumAll(List<WaterIntake>? list) {
    return (list ?? <WaterIntake>[]).fold<int>(
      0,
      (int a, WaterIntake b) => a + b.amountMl,
    );
  }

  Future<List<WaterIntake>> _withWidgetSnapshotFallback({
    required List<WaterIntake> intakes,
    required String userId,
  }) async {
    final int widgetTotal;
    try {
      widgetTotal = await WidgetService.readCurrentTotal() ?? 0;
    } on Object {
      return intakes;
    }
    final int knownTotal = _sumAll(intakes);
    if (widgetTotal <= knownTotal) {
      return intakes;
    }
    final DateTime now = DateTime.now();
    return <WaterIntake>[
      WaterIntake(
        id: 'temp-widget-${now.millisecondsSinceEpoch}',
        userId: userId,
        amountMl: widgetTotal - knownTotal,
        consumedAt: now,
        createdAt: now,
      ),
      ...intakes,
    ];
  }

  /// Добавление воды. При offline — [OfflineQueue], optimistic UI.
  Future<AddIntakeResult> addIntake(int amountMl) async {
    final String? uid = ref.read(currentUserProvider)?.id;
    if (uid == null) {
      return const AddIntakeResult();
    }
    final int goal = ref.read(dailyWaterGoalProvider).valueOrNull ??
        await ref.read(dailyWaterGoalProvider.future);
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
    state = AsyncData<List<WaterIntake>>(<WaterIntake>[
      optimistic,
      ...?state.valueOrNull,
    ]);

    final bool online = await ref.read(isOnlineNowProvider.future);
    if (!online) {
      final OfflineQueue q = await OfflineQueue.instance;
      await q.enqueueAddIntake(amountMl);
      return const AddIntakeResult(queuedOffline: true, goalFirstHit: false);
    }

    final WaterRepository repo = ref.read(waterRepositoryProvider);
    try {
      await repo.addIntakeFast(amountMl);
      final List<WaterIntake> committed = (state.valueOrNull ?? <WaterIntake>[])
          .map(
            (WaterIntake i) => i.id == tempId
                ? i.copyWith(id: 'local-${now.millisecondsSinceEpoch}')
                : i,
          )
          .toList();
      state = AsyncData<List<WaterIntake>>(committed);
      return AddIntakeResult(goalFirstHit: wouldHit, queuedOffline: false);
    } on Object {
      final OfflineQueue q = await OfflineQueue.instance;
      await q.enqueueAddIntake(amountMl);
      return AddIntakeResult(goalFirstHit: wouldHit, queuedOffline: true);
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
  final List<WaterIntake> intakes =
      ref.watch(todayIntakesProvider).valueOrNull ?? <WaterIntake>[];
  return intakes.fold<int>(0, (int sum, WaterIntake i) => sum + i.amountMl);
}

@riverpod
Future<int> dailyWaterGoal(DailyWaterGoalRef ref) async {
  ref.watch(currentUserProvider);
  final String? uid = Supabase.instance.client.auth.currentUser?.id;
  if (uid == null) {
    return 2000;
  }
  try {
    final Map<String, dynamic>? row = await Supabase.instance.client
        .from('profiles')
        .select('daily_goal_ml')
        .eq('id', uid)
        .maybeSingle();
    if (row == null) {
      return 2000;
    }
    return (row['daily_goal_ml'] as num?)?.toInt() ?? 2000;
  } on Object {
    return 2000;
  }
}
