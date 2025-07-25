import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/utils/sql/sql_util.dart';
import 'package:postgres/postgres.dart';

/// Base repository for CRUD operations. Extend this for each feature.
abstract class BaseRepository<D extends BaseDto, E extends BaseEntity> {
  final Connection connection;
  final String tableName;

  const BaseRepository(this.connection, this.tableName);

  E fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(E entity);

  Future<List<E>> findAll() async {
    return await SqlUtil.readAll<E>(
        table: tableName, connection: connection, fromJson: fromJson);
  }

  Future<E?> findById(String id) async {
    return await SqlUtil.read<E>(
        table: tableName, connection: connection, fromJson: fromJson);
  }

  Future<void> create(E entity) async => await SqlUtil.create(
        table: tableName,
        data: toJson(entity),
        connection: connection,
      );

  Future<void> update(String id, E entity) async {
    await SqlUtil.update(
      connection: connection,
      table: tableName,
      data: toJson(entity),
      where: 'id = @id',
      whereParams: {
        'id': id,
      },
    );
  }

  Future<void> delete(String id) async {
    await SqlUtil.delete(
      connection: connection,
      table: tableName,
      where: 'id = @id',
      whereParams: {
        'id': id,
      },
    );
  }
}
