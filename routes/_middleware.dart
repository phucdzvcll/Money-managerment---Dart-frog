import 'package:dart_frog/dart_frog.dart';
import 'package:mm/di/container.dart';

Handler middleware(Handler handler) {
  return handler.use(dbMiddleware(handler));
}
