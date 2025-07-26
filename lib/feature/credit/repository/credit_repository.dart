import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/feature/auth/entities/user_entity.dart';
import 'package:mm/feature/credit/entities/credit_entity.dart';
import 'package:postgres/postgres.dart';

abstract class CreditRepository extends BaseRepository<CreditEntity> {
  const CreditRepository(Connection connection, UserEntity userEntity)
      : super(connection, 'credits', userEntity);
}

class CreditRepositoryImpl extends CreditRepository {
  const CreditRepositoryImpl(Connection connection, UserEntity userEntity)
      : super(connection, userEntity);

  @override
  CreditEntity fromJson(Map<String, dynamic> json) {
    return CreditEntity.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(CreditEntity entity) {
    return entity.toJson();
  }
}
