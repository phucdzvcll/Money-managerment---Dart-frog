import 'package:dart_frog/dart_frog.dart';
import 'package:mm/feature/auth/repository/user_repository.dart';
import 'package:mm/feature/auth/service/auth_service.dart';
import 'package:postgres/postgres.dart';

Middleware _userRepositoryMiddleware(Handler handler) {
  return provider<UserRepository>((context) {
    final connection = context.read<Connection>();
    return UserRepository(connection);
  });
}

Middleware _authServiceMiddleware(Handler handler) {
  return provider<AuthService>((ctx) {
    final userRepository = ctx.read<UserRepository>();
    return AuthServiceImpl(userRepository);
  });
}

Handler middleware(Handler handler) {
  return handler
      .use(_authServiceMiddleware(handler))
      .use(_userRepositoryMiddleware(handler));
}
