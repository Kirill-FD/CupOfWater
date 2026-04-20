// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      displayName: json['display_name'] as String?,
      dailyGoalMl: (json['daily_goal_ml'] as num?)?.toInt() ?? 2000,
      reminderEnabled: json['reminder_enabled'] as bool? ?? true,
      reminderIntervalMinutes:
          (json['reminder_interval_minutes'] as num?)?.toInt() ?? 60,
      reminderStartTime: json['reminder_start_time'] as String? ?? '09:00:00',
      reminderEndTime: json['reminder_end_time'] as String? ?? '22:00:00',
      timezone: json['timezone'] as String? ?? 'UTC',
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'daily_goal_ml': instance.dailyGoalMl,
      'reminder_enabled': instance.reminderEnabled,
      'reminder_interval_minutes': instance.reminderIntervalMinutes,
      'reminder_start_time': instance.reminderStartTime,
      'reminder_end_time': instance.reminderEndTime,
      'timezone': instance.timezone,
    };
