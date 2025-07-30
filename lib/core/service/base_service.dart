import 'package:dart_either/dart_either.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/model/base_mapper.dart';
import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/core/service/service_mixin.dart';

abstract base class BaseService<
    E extends BaseEntity,
    RQ extends BaseRequestDto,
    RP extends BaseResponseDto,
    R extends BaseRepository<E>,
    M extends BaseMapper<RQ, E, RP>> with ServiceMixin {
  const BaseService(this.repository, this.mapper);

  final R repository;

  final M mapper;

  Future<List<E>> getAll() async {
    return repository.findAll();
  }

  Future<E?> getById(int id) async {
    return repository.findById(id);
  }

  Future<Either<ApiError, void>> deleteById(int id) async {
    return call(
      fn: () async {
        await repository.delete(id.toString());
      },
      mapper: (_) {},
    );
  }

  Future<Either<ApiError, RP>> create(
    RQ input,
  ) {
    return call(
      fn: () async {
        final entity = mapper.fromRequestDto(input);
        return repository.create(entity);
      },
      mapper: mapper.toResponseDto,
    );
  }

  Future<Either<ApiError, RP>> update(
    RQ dto,
  ) {
    return call(
      fn: () async {
        final entity = mapper.fromRequestDto(dto);
        return repository.update(entity);
      },
      mapper: mapper.toResponseDto,
    );
  }

  Future<Either<ApiError, List<RP>>> excuteGetAll() {
    return calls<RP, E>(
      fn: () async {
        final all = await getAll();
        return all;
      },
      mapper: mapper.toResponseDto,
    );
  }

  Future<Either<ApiError, RP>> excuteGetById(int id) {
    return call(
      fn: () async {
        final result = await getById(id);
        if (result == null) {
          throw const ApiError(
            code: NOT_FOUND,
            message: 'Entity not found',
            statusCode: 400,
          );
        }
        return result;
      },
      mapper: mapper.toResponseDto,
    );
  }
}
