// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_intake.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WaterIntakeImpl _$$WaterIntakeImplFromJson(Map<String, dynamic> json) =>
    _$WaterIntakeImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amountMl: (json['amount_ml'] as num).toInt(),
      consumedAt: DateTime.parse(json['consumed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$WaterIntakeImplToJson(_$WaterIntakeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'amount_ml': instance.amountMl,
      'consumed_at': instance.consumedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
