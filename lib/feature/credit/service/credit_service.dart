import 'package:mm/core/service/base_service.dart';
import 'package:mm/feature/credit/dto/credit_dto.dart';
import 'package:mm/feature/credit/entities/credit_entity.dart';
import 'package:mm/feature/credit/repository/credit_repository.dart';

abstract base class CreditService
    extends BaseService<CreditEntity, CreditDto, CreditRepository> {
  CreditService(super.repository);
}

base class CreditServiceImpl extends CreditService {
  CreditServiceImpl(super.repository);

  @override
  Future<CreditEntity> create(CreditDto entity) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<CreditDto>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<CreditDto?> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<CreditEntity> update(int id, CreditEntity entity) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  CreditEntity mapper(CreditDto dto) {
    return dto.toEntity;
  }

  @override
  CreditDto converter(CreditEntity entity) {
    return entity.toDto;
  }
}
