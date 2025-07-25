import 'package:dart_frog/dart_frog.dart';
import 'package:mm/feature/auth/repository/user_repository.dart';
import 'package:mm/feature/auth/service/auth_service.dart';
import 'package:postgres/postgres.dart';

Middleware _userRepositoryMiddleware(Handler handler) {
  return provider<Future<UserRepository>>((context) async {
    final connection = await context.read<Future<Connection>>();
    return UserRepository(connection);
  });
}

Middleware _authServiceMiddleware(Handler handler) {
  return provider<Future<AuthService>>((ctx) async {
    final userRepository = await ctx.read<Future<UserRepository>>();
    return AuthServiceImpl(userRepository);
  });
}

Handler middleware(Handler handler) {
  return handler
      .use(_authServiceMiddleware(handler))
      .use(_userRepositoryMiddleware(handler));
}
