import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:water_tracker/core/security/input_sanitizer.dart';
import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:water_tracker/shared/services/notification_service.dart';
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/settings/data/settings_repository.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';
import 'package:water_tracker/shared/services/profile_update_queue.dart';

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
    final User? user = ref.watch(currentUserProvider);
    if (user == null) {
      throw StateError('Not authenticated');
    }
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
    final UserProfile? previousProfile = state.valueOrNull;
    if (previousProfile != null) {
      state = AsyncValue<UserProfile>.data(
        previousProfile.copyWith(dailyGoalMl: goalMl),
      );
    }
    await _applyProfileUpdate(() async {
      final UserProfile p = await ref
          .read(settingsRepositoryProvider)
          .updateProfile(<String, dynamic>{'daily_goal_ml': goalMl});
      ref.invalidate(dailyWaterGoalProvider);
      return p;
    });
  }

  Future<void> updateDisplayName(String name) async {
    final String safeName = InputSanitizer.sanitizeDisplayName(name);
    final Map<String, dynamic> updates = <String, dynamic>{
      'display_name': safeName.isEmpty ? null : safeName,
    };
    final UserProfile? previousProfile = state.valueOrNull;
    if (previousProfile != null) {
      state = AsyncValue<UserProfile>.data(
        previousProfile.copyWith(
          displayName: safeName.isEmpty ? null : safeName,
        ),
      );
    }
    try {
      final UserProfile profile = await ref
          .read(settingsRepositoryProvider)
          .updateProfile(updates);
      state = AsyncValue<UserProfile>.data(profile);
    } on Object {
      final ProfileUpdateQueue queue = await ProfileUpdateQueue.instance;
      await queue.enqueue(updates);
    }
  }

  Future<void> flushPendingProfileUpdates() async {
    try {
      final bool changed = await (await ProfileUpdateQueue.instance).flush(
        Supabase.instance.client,
      );
      if (changed) {
        ref.invalidateSelf();
      }
    } on Object {
      // Очередь профиля будет повторно отправлена при следующем resume/online.
    }
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
          .updateProfile(<String, dynamic>{
            'reminder_enabled': enabled,
            'reminder_interval_minutes': intervalMinutes,
            'reminder_start_time': timeOfDayToHms(startTime),
            'reminder_end_time': timeOfDayToHms(endTime),
          });
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
