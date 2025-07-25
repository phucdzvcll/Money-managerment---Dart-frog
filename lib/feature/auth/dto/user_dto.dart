import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/date_time_converter.dart';
import 'package:mm/feature/auth/entities/user_entity.dart';

part 'user_dto.freezed.dart';

part 'user_dto.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class UserDto with _$UserDto implements BaseDto {
  const factory UserDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'password_hash') String? passwordHash,
    @JsonKey(
        name: 'created_at',
        toJson: DateTimeConverter.toJson,
        fromJson: DateTimeConverter.fromJson)
    DateTime? createdAt,
    @JsonKey(
        name: 'updated_at',
        toJson: DateTimeConverter.toJson,
        fromJson: DateTimeConverter.fromJson)
    DateTime? updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, Object?> json) =>
      _$UserDtoFromJson(json);
}

extension UserDtoExtension on UserDto {
  UserEntity get toEntity => UserEntity(
        id: id!,
        username: username,
        fullName: fullName,
        token: '',
        rToken: '',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
