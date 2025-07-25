import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/feature/credit/dto/credit_dto.dart';
import 'package:mm/feature/credit/entities/credit_entity.dart';

abstract class CreditRepository
    extends BaseRepository<CreditDto, CreditEntity> {
  CreditRepository(super.connection, super.tableName);
}

class CreditRepositoryImpl extends CreditRepository {
  CreditRepositoryImpl(super.connection, super.tableName);

  @override
  CreditEntity fromJson(Map<String, dynamic> json) {
    return CreditEntity.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(CreditEntity entity) {
    return entity.toJson();
  }
}
