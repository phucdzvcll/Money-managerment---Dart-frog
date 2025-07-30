import 'package:dart_either/dart_either.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/model/base_mapper.dart';
import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/core/service/service_mixin.dart';
import 'package:postgres/postgres.dart';

abstract base class BaseService<
    E extends BaseEntity,
    RQ extends BaseRequestDto,
    RP extends BaseResponseDto,
    R extends BaseRepository<E>,
    M extends BaseMapper<RQ, E, RP>> with ServiceMixin {
  const BaseService(this.repository, this.mapper, this.connection);

  final R repository;

  final M mapper;
  final Connection connection;

  Future<List<E>> getAll({Session? s}) async {
    return connection.runTx((s) async {
      return repository.findAll(s: s);
    });
  }

  Future<E?> getById(int id, {Session? s}) async {
    return connection.runTx((s) async {
      return repository.findById(id, s: s);
    });
  }

  Future<Either<ApiError, void>> deleteById(int id, {Session? s}) async {
    return call(
      fn: () async {
        return connection.runTx((s) async {
          await repository.delete(id.toString(), s: s);
        });
      },
      mapper: (_) {},
    );
  }

  Future<Either<ApiError, RP>> create(RQ input, {Session? s}) {
    return call(
      fn: () async {
        return connection.runTx((s) async {
          final entity = mapper.fromRequestDto(input);
          return repository.create(entity, s: s);
        });
      },
      mapper: mapper.toResponseDto,
    );
  }

  Future<Either<ApiError, RP>> update(RQ dto, {Session? s}) {
    return call(
      fn: () async {
        return connection.runTx((s) async {
          final entity = mapper.fromRequestDto(dto);
          return repository.update(entity, s: s);
        });
      },
      mapper: mapper.toResponseDto,
    );
  }

  Future<Either<ApiError, List<RP>>> excuteGetAll({Session? s}) {
    return calls<RP, E>(
      fn: () async {
        return connection.runTx((s) async {
          final all = await getAll(s: s);
          return all;
        });
      },
      mapper: mapper.toResponseDto,
    );
  }

  Future<Either<ApiError, RP>> excuteGetById(int id, {Session? s}) {
    return call(
      fn: () async {
        return connection.runTx((s) async {
          final result = await getById(id, s: s);
          if (result == null) {
            throw const ApiError(
              code: NOT_FOUND,
              message: 'Entity not found',
              statusCode: 400,
            );
          }
          return result;
        });
      },
      mapper: mapper.toResponseDto,
    );
  }
}
