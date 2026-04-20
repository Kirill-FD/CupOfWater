// ignore_for_file: invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'daily_goal_ml') @Default(2000) int dailyGoalMl,
    @JsonKey(name: 'reminder_enabled') @Default(true) bool reminderEnabled,
    @JsonKey(name: 'reminder_interval_minutes') @Default(60) int reminderIntervalMinutes,
    @JsonKey(name: 'reminder_start_time')
    @Default('09:00:00')
    String reminderStartTime,
    @JsonKey(name: 'reminder_end_time')
    @Default('22:00:00')
    String reminderEndTime,
    @Default('UTC') String timezone,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

extension UserProfileTimeX on UserProfile {
  TimeOfDay get startTimeOfDay => _timeOfDayFromHhMmSs(reminderStartTime);

  TimeOfDay get endTimeOfDay => _timeOfDayFromHhMmSs(reminderEndTime);
}

TimeOfDay _timeOfDayFromHhMmSs(String raw) {
  final List<String> segments = raw.trim().split(':');
  if (segments.length < 2) {
    return const TimeOfDay(hour: 0, minute: 0);
  }
  final int hour = int.tryParse(segments[0]) ?? 0;
  final int minute = int.tryParse(segments[1]) ?? 0;
  return TimeOfDay(
    hour: hour.clamp(0, 23),
    minute: minute.clamp(0, 59),
  );
}
