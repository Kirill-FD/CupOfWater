// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_goal_ml')
  int get dailyGoalMl => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_enabled')
  bool get reminderEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_interval_minutes')
  int get reminderIntervalMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_start_time')
  String get reminderStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_end_time')
  String get reminderEndTime => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
    UserProfile value,
    $Res Function(UserProfile) then,
  ) = _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'daily_goal_ml') int dailyGoalMl,
    @JsonKey(name: 'reminder_enabled') bool reminderEnabled,
    @JsonKey(name: 'reminder_interval_minutes') int reminderIntervalMinutes,
    @JsonKey(name: 'reminder_start_time') String reminderStartTime,
    @JsonKey(name: 'reminder_end_time') String reminderEndTime,
    String timezone,
  });
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = freezed,
    Object? dailyGoalMl = null,
    Object? reminderEnabled = null,
    Object? reminderIntervalMinutes = null,
    Object? reminderStartTime = null,
    Object? reminderEndTime = null,
    Object? timezone = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            dailyGoalMl: null == dailyGoalMl
                ? _value.dailyGoalMl
                : dailyGoalMl // ignore: cast_nullable_to_non_nullable
                      as int,
            reminderEnabled: null == reminderEnabled
                ? _value.reminderEnabled
                : reminderEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            reminderIntervalMinutes: null == reminderIntervalMinutes
                ? _value.reminderIntervalMinutes
                : reminderIntervalMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            reminderStartTime: null == reminderStartTime
                ? _value.reminderStartTime
                : reminderStartTime // ignore: cast_nullable_to_non_nullable
                      as String,
            reminderEndTime: null == reminderEndTime
                ? _value.reminderEndTime
                : reminderEndTime // ignore: cast_nullable_to_non_nullable
                      as String,
            timezone: null == timezone
                ? _value.timezone
                : timezone // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
    _$UserProfileImpl value,
    $Res Function(_$UserProfileImpl) then,
  ) = __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'daily_goal_ml') int dailyGoalMl,
    @JsonKey(name: 'reminder_enabled') bool reminderEnabled,
    @JsonKey(name: 'reminder_interval_minutes') int reminderIntervalMinutes,
    @JsonKey(name: 'reminder_start_time') String reminderStartTime,
    @JsonKey(name: 'reminder_end_time') String reminderEndTime,
    String timezone,
  });
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
    _$UserProfileImpl _value,
    $Res Function(_$UserProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = freezed,
    Object? dailyGoalMl = null,
    Object? reminderEnabled = null,
    Object? reminderIntervalMinutes = null,
    Object? reminderStartTime = null,
    Object? reminderEndTime = null,
    Object? timezone = null,
  }) {
    return _then(
      _$UserProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        dailyGoalMl: null == dailyGoalMl
            ? _value.dailyGoalMl
            : dailyGoalMl // ignore: cast_nullable_to_non_nullable
                  as int,
        reminderEnabled: null == reminderEnabled
            ? _value.reminderEnabled
            : reminderEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        reminderIntervalMinutes: null == reminderIntervalMinutes
            ? _value.reminderIntervalMinutes
            : reminderIntervalMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        reminderStartTime: null == reminderStartTime
            ? _value.reminderStartTime
            : reminderStartTime // ignore: cast_nullable_to_non_nullable
                  as String,
        reminderEndTime: null == reminderEndTime
            ? _value.reminderEndTime
            : reminderEndTime // ignore: cast_nullable_to_non_nullable
                  as String,
        timezone: null == timezone
            ? _value.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl({
    required this.id,
    @JsonKey(name: 'display_name') this.displayName,
    @JsonKey(name: 'daily_goal_ml') this.dailyGoalMl = 2000,
    @JsonKey(name: 'reminder_enabled') this.reminderEnabled = true,
    @JsonKey(name: 'reminder_interval_minutes')
    this.reminderIntervalMinutes = 60,
    @JsonKey(name: 'reminder_start_time') this.reminderStartTime = '09:00:00',
    @JsonKey(name: 'reminder_end_time') this.reminderEndTime = '22:00:00',
    this.timezone = 'UTC',
  });

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;
  @override
  @JsonKey(name: 'daily_goal_ml')
  final int dailyGoalMl;
  @override
  @JsonKey(name: 'reminder_enabled')
  final bool reminderEnabled;
  @override
  @JsonKey(name: 'reminder_interval_minutes')
  final int reminderIntervalMinutes;
  @override
  @JsonKey(name: 'reminder_start_time')
  final String reminderStartTime;
  @override
  @JsonKey(name: 'reminder_end_time')
  final String reminderEndTime;
  @override
  @JsonKey()
  final String timezone;

  @override
  String toString() {
    return 'UserProfile(id: $id, displayName: $displayName, dailyGoalMl: $dailyGoalMl, reminderEnabled: $reminderEnabled, reminderIntervalMinutes: $reminderIntervalMinutes, reminderStartTime: $reminderStartTime, reminderEndTime: $reminderEndTime, timezone: $timezone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.dailyGoalMl, dailyGoalMl) ||
                other.dailyGoalMl == dailyGoalMl) &&
            (identical(other.reminderEnabled, reminderEnabled) ||
                other.reminderEnabled == reminderEnabled) &&
            (identical(
                  other.reminderIntervalMinutes,
                  reminderIntervalMinutes,
                ) ||
                other.reminderIntervalMinutes == reminderIntervalMinutes) &&
            (identical(other.reminderStartTime, reminderStartTime) ||
                other.reminderStartTime == reminderStartTime) &&
            (identical(other.reminderEndTime, reminderEndTime) ||
                other.reminderEndTime == reminderEndTime) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    displayName,
    dailyGoalMl,
    reminderEnabled,
    reminderIntervalMinutes,
    reminderStartTime,
    reminderEndTime,
    timezone,
  );

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(this);
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile({
    required final String id,
    @JsonKey(name: 'display_name') final String? displayName,
    @JsonKey(name: 'daily_goal_ml') final int dailyGoalMl,
    @JsonKey(name: 'reminder_enabled') final bool reminderEnabled,
    @JsonKey(name: 'reminder_interval_minutes')
    final int reminderIntervalMinutes,
    @JsonKey(name: 'reminder_start_time') final String reminderStartTime,
    @JsonKey(name: 'reminder_end_time') final String reminderEndTime,
    final String timezone,
  }) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;
  @override
  @JsonKey(name: 'daily_goal_ml')
  int get dailyGoalMl;
  @override
  @JsonKey(name: 'reminder_enabled')
  bool get reminderEnabled;
  @override
  @JsonKey(name: 'reminder_interval_minutes')
  int get reminderIntervalMinutes;
  @override
  @JsonKey(name: 'reminder_start_time')
  String get reminderStartTime;
  @override
  @JsonKey(name: 'reminder_end_time')
  String get reminderEndTime;
  @override
  String get timezone;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
