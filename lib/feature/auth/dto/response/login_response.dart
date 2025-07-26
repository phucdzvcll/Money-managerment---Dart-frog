import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/date_time_converter.dart';

part 'login_response.freezed.dart';

part 'login_response.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse implements BaseResponseDto {
  const factory LoginResponse({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'token') required String token,
    @JsonKey(name: 'rToken') required String rToken,
    @JsonKey(name: 'created_at', toJson: DateTimeConverter.toJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', toJson: DateTimeConverter.toJson)
    DateTime? updatedAt,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, Object?> json) =>
      _$LoginResponseFromJson(json);
}
