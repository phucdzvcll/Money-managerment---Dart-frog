import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/feature/account/entities/account_entity.dart';
import 'package:postgres/postgres.dart';

abstract class AccountRepository extends BaseRepository<AccountEntity> {
  const AccountRepository(Connection connection)
      : super(connection, 'accounts');
}

class AccountRepositoryImpl extends AccountRepository {
  const AccountRepositoryImpl(Connection connection)
      : super(connection);

  @override
  AccountEntity fromJson(Map<String, dynamic> json) {
    return AccountEntity.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(AccountEntity entity) {
    return entity.toJson();
  }
}
