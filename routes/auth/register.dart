import 'package:dart_frog/dart_frog.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/models/user_dto.dart';
import 'package:mm/services/auth_service.dart';
import 'package:mm/utils/response/api_response.dart';

Future<Response> onRequest(RequestContext context) async {
  final service = await context.read<Future<AuthService>>();

  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username']?.toString().trim();
  final password = body['password']?.toString();
  final fullName = body['full_name']?.toString();
  ApiResponse<ApiResponseBase>? error;
  if (username == null || username.isEmpty) {
    error = const ApiResponse.error(
        success: false, error: ApiError(code: USER_NAME_IS_EMPTY));
  } else if (password == null || password.isEmpty) {
    error = const ApiResponse.error(
        success: false, error: ApiError(code: PASSWORD_IS_EMPTY));
  } else {
    final result = await service.signUp(username, password);
    return result.fold(
      ifLeft: (e) {
        error = ApiResponse.error(success: false, error: e);
        return Response.json(
          body: error!.toJson((e) => {}),
        );
      },
      ifRight: (r) {
        return ApiResponse<UserDto>.success(
          success: true,
          data: UserDto(username: username, fullName: fullName),
        ).toResponse();
      },
    );
  }
  return error.toResponse();
}
