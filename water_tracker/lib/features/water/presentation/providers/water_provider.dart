import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/water/data/water_repository.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/shared/services/widget_service.dart';

part 'water_provider.g.dart';

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

  Future<void> addIntake(int amountMl) async {
    final WaterRepository repo = ref.read(waterRepositoryProvider);
    final String? uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) {
      return;
    }
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
    try {
      await repo.addIntake(amountMl);
      ref.invalidateSelf();
      await WidgetService.updateWidget();
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
      await WidgetService.updateWidget();
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
