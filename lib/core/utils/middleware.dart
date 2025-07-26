import 'package:dart_frog/dart_frog.dart';
import 'package:mm/feature/auth/entities/user_entity.dart';
import 'package:postgres/postgres.dart';

typedef ConnectionUserCustomProvider<T> = T Function(
  Connection connection,
  UserEntity userEntity,
  RequestContext context,
);
typedef ConnectionCustomProvider<T> = T Function(
  Connection connection,
  RequestContext context,
);
typedef UserCustomProvider<T> = T Function(
  UserEntity user,
  RequestContext context,
);

Middleware connectionUserMiddleware<T>(
  Handler handler,
  ConnectionUserCustomProvider<T> customProvider,
) {
  return provider<T>((context) {
    final userEntity = context.read<UserEntity>();
    final connection = context.read<Connection>();
    return customProvider(connection, userEntity, context);
  });
}

Middleware userMiddleware<T>(
  Handler handler,
  UserCustomProvider<T> customProvider,
) {
  return provider<T>((context) {
    final userEntity = context.read<UserEntity>();
    return customProvider(userEntity, context);
  });
}

Middleware connectionMiddleware<T>(
  Handler handler,
  ConnectionCustomProvider<T> customProvider,
) {
  return provider<T>((context) {
    final connection = context.read<Connection>();
    return customProvider(connection, context);
  });
}
