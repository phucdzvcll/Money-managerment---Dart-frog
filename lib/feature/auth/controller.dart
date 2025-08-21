import 'package:dart_frog/dart_frog.dart';
import 'package:mm/builder/anotation.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/feature/auth/dto/request/login_request_dto.dart';
import 'package:mm/feature/auth/dto/response/login_response.dart';
import 'package:mm/feature/auth/service/auth_service.dart';

@OpenApi(
  path: '/auth/login',
  method: 'POST',
  tag: 'auth',
  summary: 'Login user',
  requestSchema: 'login_request_dto.openapi_schema.json',
  responseSchema: 'login_response.openapi_schema.json',
)
Future<Response> loginRequest(RequestContext context) async {
  final service = context.read<AuthService>();

  final body = await context.request.json() as Map<String, dynamic>;
  ErrorResponse error;
  try {
    final loginRequest = LoginRequestDto.fromJson(body);

    if (loginRequest.username.isEmpty) {
      error = const ErrorResponse(
        error: ApiError(
            code: ErrorCode.USER_NAME_IS_EMPTY,
            statusCode: 400,
            message: 'USER_NAME_IS_EMPTY'),
      );
    } else if (loginRequest.password.isEmpty) {
      error = const ErrorResponse(
        error: ApiError(
            code: ErrorCode.PASSWORD_IS_EMPTY,
            statusCode: 400,
            message: 'PASSWORD_IS_EMPTY'),
      );
    } else {
      final result = await service.login(loginRequest);
      return result.fold(
        ifLeft: (ApiError e) {
          error = ErrorResponse(error: e);
          return error.toResponse();
        },
        ifRight: (LoginResponse userEntity) {
          final isWeb = context.request.headers['X-Client-Platform'] == 'w';
          if (isWeb) {
            final userEntity2 = userEntity.copyWith(token: '', rToken: '');
            return SuccessResponse(
              data: userEntity2,
            ).toResponse(
              headers: {
                'set-cookie':
                    'access_token=${userEntity.token}; HttpOnly; Secure; SameSite=Strict; Path=/; Max-Age=6800',
              },
            );
          } else {
            return SuccessResponse(
              data: userEntity,
            ).toResponse();
          }
        },
      );
    }
  } catch (e) {
    error = ErrorResponse(
      error: ApiError(
        code: ErrorCode.UNKNOWN_ERROR,
        message: e.toString(),
        statusCode: 500,
      ),
    );
  }

  return error.toResponse();
}

@OpenApi(
  path: '/auth/register',
  method: 'POST',
  tag: 'auth',
  summary: 'regis new user',
  requestSchema: '',
)
Future<Response> registerRequest(RequestContext context) async {
  final service = context.read<AuthService>();

  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username']?.toString().trim();
  final password = body['password']?.toString();
  final fullName = body['full_name']?.toString();
  ErrorResponse error;
  if (username == null || username.isEmpty) {
    error = const ErrorResponse(
      error: ApiError(
        code: ErrorCode.USER_NAME_IS_EMPTY,
        statusCode: 400,
      ),
    );
  } else if (password == null || password.isEmpty) {
    error = const ErrorResponse(
      error: ApiError(
        code: ErrorCode.PASSWORD_IS_EMPTY,
        statusCode: 400,
      ),
    );
  } else {
    final result = await service.signUp(username, password, fullName);
    return result.fold(
      ifLeft: (e) {
        error = ErrorResponse(error: e);
        return error.toResponse();
      },
      ifRight: (r) {
        return emptyResponse;
      },
    );
  }
  return error.toResponse();
}
