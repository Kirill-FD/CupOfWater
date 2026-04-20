// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_intake.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WaterIntake _$WaterIntakeFromJson(Map<String, dynamic> json) {
  return _WaterIntake.fromJson(json);
}

/// @nodoc
mixin _$WaterIntake {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_ml')
  int get amountMl => throw _privateConstructorUsedError;
  @JsonKey(name: 'consumed_at')
  DateTime get consumedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this WaterIntake to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WaterIntake
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaterIntakeCopyWith<WaterIntake> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaterIntakeCopyWith<$Res> {
  factory $WaterIntakeCopyWith(
    WaterIntake value,
    $Res Function(WaterIntake) then,
  ) = _$WaterIntakeCopyWithImpl<$Res, WaterIntake>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'amount_ml') int amountMl,
    @JsonKey(name: 'consumed_at') DateTime consumedAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$WaterIntakeCopyWithImpl<$Res, $Val extends WaterIntake>
    implements $WaterIntakeCopyWith<$Res> {
  _$WaterIntakeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaterIntake
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amountMl = null,
    Object? consumedAt = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            amountMl: null == amountMl
                ? _value.amountMl
                : amountMl // ignore: cast_nullable_to_non_nullable
                      as int,
            consumedAt: null == consumedAt
                ? _value.consumedAt
                : consumedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WaterIntakeImplCopyWith<$Res>
    implements $WaterIntakeCopyWith<$Res> {
  factory _$$WaterIntakeImplCopyWith(
    _$WaterIntakeImpl value,
    $Res Function(_$WaterIntakeImpl) then,
  ) = __$$WaterIntakeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'amount_ml') int amountMl,
    @JsonKey(name: 'consumed_at') DateTime consumedAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$WaterIntakeImplCopyWithImpl<$Res>
    extends _$WaterIntakeCopyWithImpl<$Res, _$WaterIntakeImpl>
    implements _$$WaterIntakeImplCopyWith<$Res> {
  __$$WaterIntakeImplCopyWithImpl(
    _$WaterIntakeImpl _value,
    $Res Function(_$WaterIntakeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaterIntake
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amountMl = null,
    Object? consumedAt = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$WaterIntakeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        amountMl: null == amountMl
            ? _value.amountMl
            : amountMl // ignore: cast_nullable_to_non_nullable
                  as int,
        consumedAt: null == consumedAt
            ? _value.consumedAt
            : consumedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WaterIntakeImpl implements _WaterIntake {
  const _$WaterIntakeImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'amount_ml') required this.amountMl,
    @JsonKey(name: 'consumed_at') required this.consumedAt,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$WaterIntakeImpl.fromJson(Map<String, dynamic> json) =>
      _$$WaterIntakeImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'amount_ml')
  final int amountMl;
  @override
  @JsonKey(name: 'consumed_at')
  final DateTime consumedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'WaterIntake(id: $id, userId: $userId, amountMl: $amountMl, consumedAt: $consumedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaterIntakeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amountMl, amountMl) ||
                other.amountMl == amountMl) &&
            (identical(other.consumedAt, consumedAt) ||
                other.consumedAt == consumedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, amountMl, consumedAt, createdAt);

  /// Create a copy of WaterIntake
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaterIntakeImplCopyWith<_$WaterIntakeImpl> get copyWith =>
      __$$WaterIntakeImplCopyWithImpl<_$WaterIntakeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WaterIntakeImplToJson(this);
  }
}

abstract class _WaterIntake implements WaterIntake {
  const factory _WaterIntake({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'amount_ml') required final int amountMl,
    @JsonKey(name: 'consumed_at') required final DateTime consumedAt,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$WaterIntakeImpl;

  factory _WaterIntake.fromJson(Map<String, dynamic> json) =
      _$WaterIntakeImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'amount_ml')
  int get amountMl;
  @override
  @JsonKey(name: 'consumed_at')
  DateTime get consumedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of WaterIntake
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaterIntakeImplCopyWith<_$WaterIntakeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
