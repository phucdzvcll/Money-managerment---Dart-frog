import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/feature/installments/entities/installments_entity.dart';
import 'package:postgres/postgres.dart';

abstract class InstallmentsRepository extends BaseRepository<InstallmentsEntity> {
  const InstallmentsRepository(Connection connection)
      : super(connection, 'installments');
}

class InstallmentsRepositoryImpl extends InstallmentsRepository {
  const InstallmentsRepositoryImpl(Connection connection)
      : super(connection);

  @override
  InstallmentsEntity fromJson(Map<String, dynamic> json) {
    return InstallmentsEntity.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(InstallmentsEntity entity) {
    return entity.toJson();
  }
}
