import 'package:dart_frog/dart_frog.dart';
import 'package:mm/repositories/user_repository.dart';
import 'package:mm/services/auth_service.dart';
import 'package:mm/services/database_connection.dart';
import 'package:postgres/postgres.dart';

Middleware authMiddleware(Handler handler) {
  return provider<Future<AuthService>>((ctx) async {
    final connection = await ctx.read<Future<Connection>>();
    final userRepository = UserRepository(connection);
    return AuthServiceImpl(userRepository);
  });
}

Middleware dbMiddleware(Handler handler) {
  return provider<Future<Connection>>((ctx) async {
    final connection = await db();
    return connection;
  });
}
