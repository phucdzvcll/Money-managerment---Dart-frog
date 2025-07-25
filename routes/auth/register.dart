import 'package:dart_frog/dart_frog.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/feature/auth/dto/user_dto.dart';
import 'package:mm/feature/auth/service/auth_service.dart';
import 'package:mm/core/model/api_response.dart';

Future<Response> onRequest(RequestContext context) async {
  final service = await context.read<Future<AuthService>>();

  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username']?.toString().trim();
  final password = body['password']?.toString();
  final fullName = body['full_name']?.toString();
  ErrorResponse error;
  if (username == null || username.isEmpty) {
    error = const ErrorResponse(error: ApiError(code: USER_NAME_IS_EMPTY));
  } else if (password == null || password.isEmpty) {
    error = const ErrorResponse(error: ApiError(code: PASSWORD_IS_EMPTY));
  } else {
    final result = await service.signUp(username, password, fullName);
    return result.fold(
      ifLeft: (e) {
        error = ErrorResponse(error: e);
        return error.toResponse();
      },
      ifRight: (r) {
        return SuccessResponse(
          data: UserDto(username: username, fullName: fullName),
        ).toResponse();
      },
    );
  }
  return error.toResponse();
}
