import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/utils/sql/sql_util.dart';
import 'package:mm/feature/auth/entities/user_entity.dart';
import 'package:postgres/postgres.dart';

/// Base repository for CRUD operations. Extend this for each feature.
abstract class BaseRepository<D extends BaseDto, E extends BaseEntity> {
  final Connection connection;
  final String tableName;
  final UserEntity userEntity;

  const BaseRepository(this.connection, this.tableName, this.userEntity);

  E fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(E entity);

  Future<List<E>> findAll() async {
    return SqlUtil.readAll<E>(
        table: tableName, connection: connection, fromJson: fromJson);
  }

  Future<E?> findById(int id) async {
    return SqlUtil.read<E>(
        table: tableName, connection: connection, fromJson: fromJson);
  }

  Future<E> create(E entity) async {
    final id = await SqlUtil.create(
      table: tableName,
      data: toJson(entity),
      connection: connection,
    );
    return (await findById(id))!;
  }

  Future<E> update(int id, E entity) async {
    await SqlUtil.update(
      connection: connection,
      table: tableName,
      data: toJson(entity),
      where: 'id = @id',
      whereParams: {
        'id': id,
      },
    );
    return (await findById(entity.id))!;
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
