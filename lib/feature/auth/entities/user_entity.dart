import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/model/date_time_converter.dart';

part 'user_entity.freezed.dart';

part 'user_entity.g.dart';

@freezed
abstract class UserEntity with _$UserEntity implements BaseEntity {
  const factory UserEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'password_hash') required String passwordHash,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'created_at', fromJson: DateTimeConverter.fromJsonNullable)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: DateTimeConverter.fromJsonNullable)
    DateTime? updatedAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, Object?> json) =>
      _$UserEntityFromJson(json);
}
