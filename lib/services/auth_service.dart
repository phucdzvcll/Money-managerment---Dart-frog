import 'package:dart_either/dart_either.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/repositories/user_repository.dart';
import 'package:mm/utils/response/api_response.dart';
import 'package:mm/utils/auth/password_util.dart';
import 'package:mm/services/service_mixin.dart';

abstract class AuthService {
  Future<Either<ApiError, bool>> login(String username, String password);

  Future<Either<ApiError, bool>> signUp(String username, String password);
}

class AuthServiceImpl extends AuthService with ServiceMixin {
  AuthServiceImpl(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Either<ApiError, bool>> login(String username, String password) async {
    return call(
      fn: () async {
        final user = await _userRepository.getUserByUsername(username);
        if (user == null) {
          throw const ApiError(code: USER_NOT_FOUND);
        }

        final passwordHash = user['password_hash'] as String;
        final isValid = PasswordUtil.verifyPassword(password, passwordHash);
        if (!isValid) {
          throw const ApiError(code: PASSWORD_INCORRECT);
        }
        return true;
      },
    );
  }

  @override
  Future<Either<ApiError, bool>> signUp(
      String username, String password) async {
    final isTaken = await _userRepository.isUsernameOrEmailTaken(username, '');
    if (isTaken) {
      return const Either.left(ApiError(code: USERNAME_ALREADY_TAKEN));
    }
    if (!PasswordUtil.isValidPassword(password)) {
      return const Either.left(ApiError(code: PASSWORD_INCORRECT, message: 'Password does not meet complexity requirements.'));
    }
    final hashedPassword = PasswordUtil.generatePasswordHash(password);

    await _userRepository.createUser(
      username: username,
      password: hashedPassword,
      fullName: '',
    );
    return const Either.right(true);
  }
}
