import 'dart:async';
import 'package:dart_frog/dart_frog.dart';
import 'package:mm/constants/bypass_route.dart';
import 'package:mm/core/utils/auth/jwt.dart';

Middleware jwtMiddleware() {
  return (handler) {
    return (context) {
      final path = context.request.uri.path;
      final url = context.request.uri.host;
      if (shouldByPass(path)) {
        return handler(context);
      }

      final platform = context.request.headers['x-client-platform'];

      if (platform == 'w') {
        final cookieHeader = context.request.headers['cookie'];
        final cookies = cookieHeader
            ?.split(';')
            .map((c) => c.trim().split('='))
            .where((c) => c.length == 2)
            .fold<Map<String, String>>({}, (map, c) {
          map[c[0]] = c[1];
          return map;
        });
        final token = cookies?['access_token'];
        return _handleToken(token, handler, context);
      }
      return _handleJwtHeader(context, handler);
    };
  };
}

FutureOr<Response> _handleJwtHeader(RequestContext context, Handler handler) {
  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: 403,
      body: {'error': 'Token invalid'},
    );
  }

  final token = authHeader.substring(7);

  return _handleToken(token, handler, context);
}

FutureOr<Response> _handleToken(
  String? token,
  Handler handler,
  RequestContext context,
) {
  final tokenIsValid = JwtUtil.verifyJwt(token);
  if (!tokenIsValid) {
    return Response.json(
      statusCode: 401,
      body: {'error': 'Invalid or expired token'},
    );
  }
  final userData = JwtUtil.decodeJwt(token);
  return handler(context.provide(() => userData));
}

bool shouldByPass(String path) {
  for (final e in bypassPath) {
    if (path.startsWith(e)) {
      return true;
    }
  }
  return false;
}
