import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:water_tracker/shared/services/notification_service.dart';
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/settings/data/settings_repository.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';

part 'settings_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SettingsRepository(Supabase.instance.client);
}

String timeOfDayToHms(TimeOfDay t) {
  return '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}:00';
}

@riverpod
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile> build() async {
    return ref.watch(settingsRepositoryProvider).getProfile();
  }

  Future<void> _applyProfileUpdate(
    Future<UserProfile> Function() update,
  ) async {
    final UserProfile? previousProfile = state.valueOrNull;
    try {
      final UserProfile profile = await update();
      state = AsyncValue<UserProfile>.data(profile);
    } on Object catch (e, st) {
      state = previousProfile != null
          ? AsyncValue<UserProfile>.data(previousProfile)
          : AsyncValue<UserProfile>.error(e, st);
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<void> updateGoal(int goalMl) async {
    await _applyProfileUpdate(() async {
      final UserProfile p = await ref
          .read(settingsRepositoryProvider)
          .updateProfile(<String, dynamic>{'daily_goal_ml': goalMl});
      ref.invalidate(dailyWaterGoalProvider);
      return p;
    });
  }

  Future<void> updateDisplayName(String name) async {
    await _applyProfileUpdate(
      () => ref
          .read(settingsRepositoryProvider)
          .updateProfile(
            <String, dynamic>{'display_name': name.isEmpty ? null : name},
          ),
    );
  }

  Future<void> updateReminders({
    required bool enabled,
    required int intervalMinutes,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    await _applyProfileUpdate(() async {
      final UserProfile p = await ref
          .read(settingsRepositoryProvider)
          .updateProfile(
            <String, dynamic>{
              'reminder_enabled': enabled,
              'reminder_interval_minutes': intervalMinutes,
              'reminder_start_time': timeOfDayToHms(startTime),
              'reminder_end_time': timeOfDayToHms(endTime),
            },
          );
      await NotificationService.instance.scheduleReminders(
        enabled: p.reminderEnabled,
        intervalMinutes: p.reminderIntervalMinutes,
        startTime: p.startTimeOfDay,
        endTime: p.endTimeOfDay,
      );
      return p;
    });
  }
}
