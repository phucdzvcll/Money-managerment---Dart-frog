import 'package:dart_frog/dart_frog.dart';
import 'package:mm/constants/bypass_route.dart';
import 'package:mm/core/utils/auth/jwt.dart';

bool shouldByPass(String path) {
  for (final e in bypassPath) {
    if (path.startsWith(e)) {
      return true;
    }
  }
  return false;
}

Middleware jwtMiddleware() {
  return (handler) {
    return (context) {
      final path = context.request.uri.path;
      if (shouldByPass(path)) {
        return handler(context);
      }

      final authHeader = context.request.headers['authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.json(
          statusCode: 403,
          body: {'error': 'Token invalid'},
        );
      }

      final token = authHeader.substring(7);
      final tokenIsValid = JwtUtil.verifyJwt(token);
      if (!tokenIsValid) {
        return Response.json(
          statusCode: 401,
          body: {'error': 'Invalid or expired token'},
        );
      }
      final userData = JwtUtil.decodeJwt(token);
      return handler(context.provide(() => userData));
    };
  };
}

Handler middleware(Handler handler) {
  // return handler.use(jwtMiddleware());
  return handler;
}
