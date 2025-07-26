import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_dto.freezed.dart';

part 'login_request_dto.g.dart';

@freezed
abstract class LoginRequestDto with _$LoginRequestDto {
  const factory LoginRequestDto({
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'password') required String password,
  }) = _LoginRequestDto;

  factory LoginRequestDto.fromJson(Map<String, Object?> json) =>
      _$LoginRequestDtoFromJson(json);
}
