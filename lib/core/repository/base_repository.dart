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

  Future<List<E>> findAll() async {
    return SqlUtil.readAll<E>(
        table: tableName, connection: connection, fromJson: fromJson);
  }

  Future<E?> findById(int id) async {
    return SqlUtil.read<E>(
      table: tableName,
      connection: connection,
      fromJson: fromJson,
      where: 'id = @id',
      parameters: {
        'id': id,
      },
    );
  }

  Future<E> create(E entity) async {
    final data = toJson(entity)..remove('id');
    final id = await SqlUtil.create(
      table: tableName,
      data: data,
      connection: connection,
    );
    final entityResult = await findById(id);
    return entityResult!;
  }

  Future<E> update(E entity) async {
    final oldEntity = await findById(entity.id);
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
      connection: connection,
      table: tableName,
      data: inputValue,
      where: 'id = @id',
      whereParams: {
        'id': entity.id,
      },
    );
    return (await findById(entity.id))!;
  }

  static Map<String, dynamic> _mergeJsonPreferNonNull(
    Map<String, dynamic> json1,
    Map<String, dynamic> json2,
  ) {
    final result = <String, dynamic>{};
    for (final key in json1.keys) {
      final value1 = json1[key];
      final value2 = json2[key];
      result[key] = value1 ?? value2;
    }
    return result;
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
