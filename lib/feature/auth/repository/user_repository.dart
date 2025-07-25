import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/core/utils/sql/sql_util.dart';
import 'package:mm/feature/auth/dto/user_dto.dart';
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

  Future<UserDto> getUserByUsername(String username) async {
    final result = await SqlUtil.read<UserDto>(
      table: 'users',
      connection: _connection,
      fromJson: UserDto.fromJson,
      where: "username = '$username'",
    );

    if (result == null) throw const ApiError(code: USER_NOT_FOUND);

    return result;
  }
}
