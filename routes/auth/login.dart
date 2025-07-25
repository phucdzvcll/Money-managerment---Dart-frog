import 'package:dart_frog/dart_frog.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/models/user_dto.dart';
import 'package:mm/services/auth_service.dart';
import 'package:mm/utils/response/api_response.dart';
import 'package:mm/utils/jwt/jwt.dart';

Future<Response> onRequest(RequestContext context) async {
  final service = await context.read<Future<AuthService>>();

  final body = await context.request.json() as Map<String, dynamic>;

  final username = body['username']?.toString().trim();
  final password = body['password']?.toString();

  ApiResponse<ApiResponseBase>? error;
  if (username == null || username.isEmpty) {
    error = const ApiResponse.error(
        success: false, error: ApiError(code: USER_NAME_IS_EMPTY));
  } else if (password == null || password.isEmpty) {
    error = const ApiResponse.error(
        success: false, error: ApiError(code: PASSWORD_IS_EMPTY));
  } else {
    final result = await service.login(username, password);
    return result.fold(
      ifLeft: (e) {
        error = ApiResponse.error(success: false, error: e);
        return Response.json(
          body: error!.toJson((e) => {}),
        );
      },
      ifRight: (userDto) {
        return ApiResponse<UserDto>.success(
          success: true,
          data: userDto.copyWith(
            token: JwtUtil.generateJwt(userDto),
            rToken: JwtUtil.generateRefeshJwt(userDto),
          ),
        ).toResponse();
      },
    );
  }
  return error.toResponse();
}
