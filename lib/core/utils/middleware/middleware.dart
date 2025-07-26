import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/core/service/base_service.dart';
import 'package:mm/feature/auth/entities/user_entity.dart';
import 'package:postgres/postgres.dart';

Middleware createRepositoryMiddleware<T extends Object?>(
  T Function(
    Connection connection,
    UserEntity userEntity,
  ) create,
) {
  return (handler) {
    return (context) => handler(
          context.provide(
            () {
              final userEntity = context.read<UserEntity>();
              final connection = context.read<Connection>();
              return create(connection, userEntity);
            },
          ),
        );
  };
}

Middleware createServiceMiddleware<E extends BaseEntity,
    R extends BaseRepository<E>, T extends BaseService<E, R>>(
  T Function(R repo) create,
) {
  return (handler) {
    return (context) {
      final repo = context.read<R>();
      return handler(context.provide(() => create(repo)));
    };
  };
}

Middleware featureMiddleware<E extends BaseEntity, R extends BaseRepository<E>,
    S extends BaseService<E, R>>(
  S Function(R repo) createService,
  R Function(Connection connection, UserEntity userEntity) createRepository,
) {
  return (handler) {
    return handler
        .use(createServiceMiddleware(createService))
        .use(createRepositoryMiddleware(createRepository));
  };
}
