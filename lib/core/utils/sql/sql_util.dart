import 'package:postgres/postgres.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class SqlUtil {
  SqlUtil();

  static Future<T?> read<T>({
    required String table,
    required Session connection,
    required FromJson<T> fromJson,
    String? where,
    Map<String, dynamic>? parameters,
  }) async {
    final sql = where != null
        ? 'SELECT * FROM $table WHERE $where'
        : 'SELECT * FROM $table';
    final result = await connection.execute(
      Sql.named(sql),
      parameters: parameters ?? {},
    );
    final data = result.map((row) => row.toColumnMap()).toList();
    if (data.isEmpty) {
      return null;
    } else {
      return fromJson(data.first);
    }
  }

  static Future<List<T>> readAll<T>({
    required String table,
    required Session connection,
    required FromJson<T> fromJson,
    String? where,
    Map<String, dynamic>? parameters,
  }) async {
    final sql = where != null
        ? 'SELECT * FROM $table WHERE $where'
        : 'SELECT * FROM $table';
    final result = await connection.execute(
      Sql.named(sql),
      parameters: parameters ?? {},
    );
    return result.map((row) => fromJson(row.toColumnMap())).toList();
  }

  static Future<String> create({
    required String table,
    required Map<String, dynamic> data,
    required Session connection,
  }) async {
    final columns = data.keys.join(', ');
    final values = data.keys.map((k) => '@$k').join(', ');
    final sql = 'INSERT INTO $table ($columns) VALUES ($values) RETURNING id';
    final result = await connection.execute(
      Sql.named(sql),
      parameters: data,
    );
    final data2 = result.map((row) => row.toColumnMap()).toList();
    if (data2.isEmpty) {
      return '';
    } else {
      return data2.first['id'] as String;
    }
  }

  static Future<void> update({
    required Session connection,
    required String table,
    required Map<String, dynamic> data,
    required String where,
    required Map<String, dynamic> whereParams,
  }) async {
    final setClause = data.keys.map((k) => '$k = @$k').join(', ');
    final sql = 'UPDATE $table SET $setClause WHERE $where';
    await connection.execute(
      Sql.named(sql),
      parameters: {...data, ...whereParams},
    );
  }

  static Future<void> delete({
    required Session connection,
    required String table,
    required String where,
    required Map<String, dynamic> whereParams,
  }) async {
    final sql = 'DELETE FROM $table WHERE $where';
    await connection.execute(
      Sql.named(sql),
      parameters: whereParams,
    );
  }
}
