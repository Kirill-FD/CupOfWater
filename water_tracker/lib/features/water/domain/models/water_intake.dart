// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_intake.freezed.dart';
part 'water_intake.g.dart';

@freezed
class WaterIntake with _$WaterIntake {
  const factory WaterIntake({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'amount_ml') required int amountMl,
    @JsonKey(name: 'consumed_at') required DateTime consumedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _WaterIntake;

  factory WaterIntake.fromJson(Map<String, dynamic> json) =>
      _$WaterIntakeFromJson(json);
}
