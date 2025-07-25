import 'package:postgres/postgres.dart';

class SqlUtil {
  final Connection connection;

  SqlUtil(this.connection);

  Future<List<Map<String, dynamic>>> read({
    required String table,
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
    return result.map((row) => row.toColumnMap()).toList();
  }

  Future<void> create({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    final columns = data.keys.join(', ');
    final values = data.keys.map((k) => '@$k').join(', ');
    final sql = 'INSERT INTO $table ($columns) VALUES ($values)';
    await connection.execute(
      Sql.named(sql),
      parameters: data,
    );
  }

  Future<void> update({
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

  Future<void> delete({
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

