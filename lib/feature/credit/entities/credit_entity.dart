import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/model/date_time_converter.dart';
import 'package:mm/core/model/numberic_converter.dart';

part 'credit_entity.freezed.dart';

part 'credit_entity.g.dart';

@freezed
abstract class CreditEntity with _$CreditEntity implements BaseEntity {
  const factory CreditEntity({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String source,
    @JsonKey(name: 'limit_amount', fromJson: NumbericConverter.fromJson)
    required double limitAmount,
    @JsonKey(name: 'due_date') required String dueDate,
    @JsonKey(name: 'statement_date') required String statementDate,
    @JsonKey(
        name: 'created_at',
        fromJson: DateTimeConverter.fromJsonNullable,
        toJson: DateTimeConverter.toJsonNullable)
    DateTime? createdAt,
    @JsonKey(
        name: 'updated_at',
        fromJson: DateTimeConverter.fromJsonNullable,
        toJson: DateTimeConverter.toJsonNullable)
    DateTime? updatedAt,
  }) = _CreditEntity;

  factory CreditEntity.fromJson(Map<String, dynamic> json) =>
      _$CreditEntityFromJson(json);
}
