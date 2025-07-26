import 'package:dart_either/dart_either.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/core/service/service_mixin.dart';

abstract base class BaseService<E extends BaseEntity,
    R extends BaseRepository<E>> with ServiceMixin {
  const BaseService(this.repository);

  final R repository;

  Future<List<E>> getAll() async{
    return repository.findAll();
  }

  Future<E?> getById(int id) async {
    return repository.findById(id);
  }

  Future<void> deleteById(int id) {
    return call(
      fn: () async {
        await repository.delete(id.toString());
      },
      mapper: (_) => null,
    );
  }

  Future<Either<ApiError, E>> create<I>(
    I input,
    E Function(I) mapper,
  ) {
    return call(
      fn: () async {
        final entity = mapper(input);
        return repository.create(entity);
      },
      mapper: (E e) => e,
    );
  }

  Future<Either<ApiError, E>> update<I>(
    int id,
    I input,
    E Function(I) mapper,
  ) {
    return call(
      fn: () async {
        final entity = mapper(input);
        return repository.update(id, entity);
      },
      mapper: (E e) => e,
    );
  }

  Future<Either<ApiError, List<I>>> excuteGetAll<I>(
    I Function(E) mapper,
  ) {
    return calls<I, E>(
      fn: () async {
        final List<E> all = await getAll();
        return all;
      },
      mapper: mapper,
    );
  }

  Future<Either<ApiError, I>> excuteGetById<I>(
    int id,
    I Function(E) mapper,
  ) {
    return call<I, E>(
      fn: () async {
        final result = await getById(id);
        if (result == null) {
          throw const ApiError(code: NOT_FOUND, message: 'Entity not found');
        }
        return result;
      },
      mapper: mapper,
    );
  }
}
