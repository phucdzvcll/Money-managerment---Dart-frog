import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/utils/sql/sql_util.dart';
import 'package:postgres/postgres.dart';

/// Base repository for CRUD operations. Extend this for each feature.
abstract class BaseRepository<E extends BaseEntity> {
  final Connection connection;
  final String tableName;

  const BaseRepository(this.connection, this.tableName);

  E fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(E entity);

  Future<List<E>> findAll({Session? s}) async {
    return SqlUtil.readAll<E>(
        table: tableName, connection: s ?? connection, fromJson: fromJson);
  }

  Future<E?> findById(String id, {Session? s}) async {
    return SqlUtil.read<E>(
      table: tableName,
      connection: s ?? connection,
      fromJson: fromJson,
      where: 'id = @id',
      parameters: {
        'id': id,
      },
    );
  }

  Future<E> create(E entity, {Session? s}) async {
    final data = toJson(entity)..remove('id');
    final id = await SqlUtil.create(
      table: tableName,
      data: data,
      connection: s ?? connection,
    );
    final entityResult = await findById(id, s: s);
    return entityResult!;
  }

  Future<E> update(E entity, {Session? s}) async {
    final oldEntity = await findById(entity.id, s: s);
    if (oldEntity == null) {
      throw ApiError(
        message: 'Entity with id ${entity.id} not found',
        code: DATA_NOT_FOUND,
        statusCode: 400,
      );
    }
    final inputValue =
        _mergeJsonPreferNonNull(toJson(oldEntity), toJson(entity));

    await SqlUtil.update(
      connection: s ?? connection,
      table: tableName,
      data: inputValue,
      where: 'id = @id',
      whereParams: {
        'id': entity.id,
      },
    );
    return (await findById(entity.id, s: s))!;
  }

  static Map<String, dynamic> _mergeJsonPreferNonNull(
    Map<String, dynamic> json1,
    Map<String, dynamic> json2,
  ) {
    final result = <String, dynamic>{};
    for (final key in json1.keys) {
      final value1 = json1[key];
      final value2 = json2[key];
      result[key] = value2 ?? value1;
    }
    return result;
  }

  Future<void> delete(String id, {Session? s}) async {
    await SqlUtil.delete(
      connection: s ?? connection,
      table: tableName,
      where: 'id = @id',
      whereParams: {
        'id': id,
      },
    );
  }
}
