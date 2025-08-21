import 'package:dart_frog/dart_frog.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';

import 'package:mm/feature/auth/controller.dart' as auth_controller;

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;
  switch (method) {
    case HttpMethod.post:
      return auth_controller.loginRequest(context);
    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return ErrorResponse(
              error: ApiError(
                  code: ErrorCode.METHOD_NOT_ALLOW,
                  statusCode: 405,
                  message: 'Method Not Allowed'))
          .toResponse();
  }
}
