import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/feature/transaction/entities/transaction_entity.dart';
import 'package:postgres/postgres.dart';

abstract class TransactionRepository extends BaseRepository<TransactionEntity> {
  const TransactionRepository(Connection connection)
      : super(connection, 'transaction');
}

class TransactionRepositoryImpl extends TransactionRepository {
  const TransactionRepositoryImpl(Connection connection) : super(connection);

  @override
  TransactionEntity fromJson(Map<String, dynamic> json) {
    return TransactionEntity.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(TransactionEntity entity) {
    return entity.toJson();
  }
}
