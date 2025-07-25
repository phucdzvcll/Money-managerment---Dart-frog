import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_entity.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
abstract class UserEntity with _$UserEntity implements BaseEntity {
  const factory UserEntity({
    @JsonKey(name: 'userId') required int id,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'token') String? token,
    @JsonKey(name: 'rToken') String? rToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, Object?> json) => _$UserEntityFromJson(json);
}

