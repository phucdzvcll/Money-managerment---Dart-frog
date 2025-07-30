import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/controller/base_controller.dart';
import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/model/base_mapper.dart';
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

Middleware createMapperMiddleware<
    RQ extends BaseRequestDto,
    E extends BaseEntity,
    RP extends BaseResponseDto,
    M extends BaseMapper<RQ, E, RP>>(
  M Function() create,
) {
  return (handler) {
    return (context) => handler(
          context.provide(
            () {
              return create();
            },
          ),
        );
  };
}

Middleware createServiceMiddleware<
    E extends BaseEntity,
    RQ extends BaseRequestDto,
    RP extends BaseResponseDto,
    R extends BaseRepository<E>,
    M extends BaseMapper<RQ, E, RP>,
    S extends BaseService<E, RQ, RP, R, M>>(
  S Function(R repo, M mapper) create,
) {
  return (handler) {
    return (context) {
      final repo = context.read<R>();
      final mapper = context.read<M>();
      return handler(context.provide(() => create(repo, mapper)));
    };
  };
}

Middleware createControllerMiddleware<
    E extends BaseEntity,
    RQ extends BaseRequestDto,
    RP extends BaseResponseDto,
    R extends BaseRepository<E>,
    M extends BaseMapper<RQ, E, RP>,
    S extends BaseService<E, RQ, RP, R, M>,
    C extends BaseController<E, RQ, RP, M, R, S>>(
  C Function(S service) create,
) {
  return (handler) {
    return (context) => handler(
          context.provide(
            () {
              final service = context.read<S>();
              return create(service);
            },
          ),
        );
  };
}

Middleware featureMiddleware<
    E extends BaseEntity,
    RQ extends BaseRequestDto,
    RP extends BaseResponseDto,
    R extends BaseRepository<E>,
    M extends BaseMapper<RQ, E, RP>,
    S extends BaseService<E, RQ, RP, R, M>,
    C extends BaseController<E, RQ, RP, M, R, S>>(
  S Function(R repo, M mapper) createService,
  R Function(Connection connection, UserEntity userEntity) createRepository,
  M Function() createMapper,
  C Function(S) createController,
) {
  return (handler) {
    return handler
        .use(createControllerMiddleware(createController))
        .use(createServiceMiddleware(createService))
        .use(createRepositoryMiddleware(createRepository))
        .use(createMapperMiddleware(createMapper));
  };
}
