import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_entity.dart';

part 'account_entity.freezed.dart';

part 'account_entity.g.dart';

@freezed
abstract class AccountEntity with _$AccountEntity implements BaseEntity {
  const factory AccountEntity({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String type,
    required String name,
    required String issuer,
    required String note,
    @JsonKey(name: 'is_archived') required bool isArchived,
    @JsonKey(name: 'deleted_at') required String deletedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AccountEntity;

  factory AccountEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountEntityFromJson(json);
}
