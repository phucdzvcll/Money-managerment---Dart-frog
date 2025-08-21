import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/middleware/cors_middleware.dart';
import 'package:mm/core/utils/middleware/jwt_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(jwtMiddleware()).use(corsMiddleware());
}
