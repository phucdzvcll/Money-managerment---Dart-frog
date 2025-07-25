import 'package:postgres/postgres.dart';

/// Base repository for CRUD operations. Extend this for each feature.
abstract class BaseRepository<T> {
  final Connection connection;
  final String tableName;

  const BaseRepository(this.connection, this.tableName);

  Future<List<T>> findAll();
  Future<T?> findById(String id);
  Future<void> create(T entity);
  Future<void> update(String id, T entity);
  Future<void> delete(String id);
}

