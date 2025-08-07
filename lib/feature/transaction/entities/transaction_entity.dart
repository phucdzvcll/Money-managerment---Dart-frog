import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_entity.dart';

part 'transaction_entity.freezed.dart';

part 'transaction_entity.g.dart';

@freezed
abstract class TransactionEntity
    with _$TransactionEntity
    implements BaseEntity {
  const factory TransactionEntity({
    required int id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);
}
