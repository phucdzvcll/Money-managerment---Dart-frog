import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/builder/anotation.dart';
import 'package:mm/core/model/base_dto.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
@OpenApiSchema()
abstract class LoginResponse with _$LoginResponse implements BaseResponseDto {
  const factory LoginResponse({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'token') required String token,
    @JsonKey(name: 'rToken') required String rToken,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, Object?> json) =>
      _$LoginResponseFromJson(json);
}
