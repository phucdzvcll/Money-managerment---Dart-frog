import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/feature/credit/entities/credit_entity.dart';
import 'package:postgres/postgres.dart';

abstract class CreditRepository extends BaseRepository<CreditEntity> {
  const CreditRepository(Connection connection)
      : super(connection, 'credits');
}

class CreditRepositoryImpl extends CreditRepository {
  const CreditRepositoryImpl(Connection connection)
      : super(connection);

  @override
  CreditEntity fromJson(Map<String, dynamic> json) {
    return CreditEntity.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(CreditEntity entity) {
    return entity.toJson();
  }
}
