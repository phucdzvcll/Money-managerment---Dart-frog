import 'package:dart_frog/dart_frog.dart';
import 'package:mm/constants/bypass_route.dart';
import 'package:mm/services/database_connection.dart';
import 'package:mm/utils/jwt/jwt.dart';
import 'package:postgres/postgres.dart';

Middleware _dbMiddleware(Handler handler) {
  return provider<Future<Connection>>((ctx) async {
    final connection = await db();
    return connection;
  });
}

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
    return (context) async {
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
      final userData = JwtUtil.verifyJwt(token);
      if (!userData) {
        return Response.json(
          statusCode: 401,
          body: {'error': 'Invalid or expired token'},
        );
      }
      return handler(context.provide(() => userData));
    };
  };
}

Handler middleware(Handler handler) {
  return handler.use(_dbMiddleware(handler)).use(jwtMiddleware());
}
