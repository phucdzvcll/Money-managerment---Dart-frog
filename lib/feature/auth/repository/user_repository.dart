import 'package:postgres/postgres.dart';

class UserRepository {
  final Connection _connection;

  UserRepository(this._connection);

  Future<bool> isUsernameOrEmailTaken(String username, String email) async {
    final result = await _connection.execute(
      Sql.named('SELECT 1 FROM users WHERE username = @username'),
      parameters: {
        'username': username,
      },
    );
    return result.isNotEmpty;
  }

  Future<void> createUser({
    required String username,
    required String password,
    String? fullName,
  }) async {
    await _connection.execute(
      Sql.named('''
      INSERT INTO users (username, password_hash, full_name)
      VALUES (@username, @password_hash, @full_name)
      '''),
      parameters: {
        'username': username,
        'password_hash': password,
        'full_name': fullName,
      },
    );
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final result = await _connection.execute(
      Sql.named(
          'SELECT id, username, password_hash, full_name FROM users WHERE username = @username'),
      parameters: {'username': username},
    );

    if (result.isEmpty) return null;

    final row = result.first.toColumnMap();
    return {
      'id': row['id'],
      'username': row['username'],
      'password_hash': row['password_hash'],
      'full_name': row['full_name'],
    };
  }
}
