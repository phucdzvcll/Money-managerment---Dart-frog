import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/utils/response/api_response.dart';

part 'user_dto.freezed.dart';

part 'user_dto.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class UserDto with _$UserDto implements ApiResponseBase {
  const factory UserDto({
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'token') String? token,
    @JsonKey(name: 'rToken') String? rToken,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, Object?> json) =>
      _$UserDtoFromJson(json);
}
