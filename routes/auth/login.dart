import 'package:dart_frog/dart_frog.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/feature/auth/dto/request/login_request_dto.dart';
import 'package:mm/feature/auth/dto/response/login_response.dart';
import 'package:mm/feature/auth/service/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final service = context.read<AuthService>();

  final body = await context.request.json() as Map<String, dynamic>;
  ErrorResponse error;
  try {
    final loginRequest = LoginRequestDto.fromJson(body);

    if (loginRequest.username.isEmpty) {
      error = const ErrorResponse(error: ApiError(code: USER_NAME_IS_EMPTY));
    } else if (loginRequest.password.isEmpty) {
      error = const ErrorResponse(error: ApiError(code: PASSWORD_IS_EMPTY));
    } else {
      final result = await service.login(loginRequest);
      return result.fold(
        ifLeft: (ApiError e) {
          error = ErrorResponse(error: e, code: 400);
          return error.toResponse();
        },
        ifRight: (LoginResponse userEntity) {
          return SuccessResponse(
            data: userEntity,
          ).toResponse();
        },
      );
    }
  } catch (e) {
    error = ErrorResponse(
        error: ApiError(code: UNKNOWN_ERROR, message: e.toString()));
  }

  return error.toResponse();
}
