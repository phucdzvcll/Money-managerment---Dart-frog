import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_entity.dart';

part 'credit_entity.freezed.dart';
part 'credit_entity.g.dart';

@freezed
abstract class CreditEntity with _$CreditEntity implements BaseEntity {
  const factory CreditEntity({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String source,
    @JsonKey(name: 'limit_amount') required double limitAmount,
    @JsonKey(name: 'due_date') required String dueDate,
    @JsonKey(name: 'statement_date') required String statementDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CreditEntity;

  factory CreditEntity.fromJson(Map<String, dynamic> json) =>
      _$CreditEntityFromJson(json);
}
