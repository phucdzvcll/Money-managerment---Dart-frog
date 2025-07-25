import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class UserDto with _$UserDto implements BaseDto {
  const factory UserDto({
    @JsonKey(name: 'userId') int? id,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'token') String? token,
    @JsonKey(name: 'rToken') String? rToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, Object?> json) =>
      _$UserDtoFromJson(json);
}
