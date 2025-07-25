import 'package:dart_either/dart_either.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/service/service_mixin.dart';

abstract base class BaseService<O extends BaseEntity, I extends BaseDto>
    with ServiceMixin {
  O mapper(I dto);

  I converter(O entity);

  Future<List<I>> getAll();

  Future<I?> getById(int id);

  Future<O> create(I dto);

  Future<O> update(int id, O dto);

  Future<bool> delete(int id);

  Future<Either<ApiError, List<O>>> excuteGetAll() {
    return calls<O, I>(
      fn: () async {
        return getAll();
      },
      mapper: mapper,
    );
  }

  Future<Either<ApiError, O>> excuteGetById(int id) {
    return call<O, I>(
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
