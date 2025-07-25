import 'package:dart_either/dart_either.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/core/service/service_mixin.dart';
import 'package:mm/core/utils/auth/jwt.dart';
import 'package:mm/core/utils/auth/password_util.dart';
import 'package:mm/feature/auth/dto/user_dto.dart';
import 'package:mm/feature/auth/entities/user_entity.dart';
import 'package:mm/feature/auth/repository/user_repository.dart';

abstract class AuthService {
  Future<Either<ApiError, UserEntity>> login(String username, String password);

  Future<Either<ApiError, bool>> signUp(
    String username,
    String password,
    String? fullName,
  );
}

class AuthServiceImpl extends AuthService with ServiceMixin {
  AuthServiceImpl(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Either<ApiError, UserEntity>> login(
      String username, String password) async {
    return call(
      mapper: (e) => e,
      fn: () async {
        final user = await _userRepository.getUserByUsername(username);

        final passwordHash = user.passwordHash ?? '';
        final isValid = PasswordUtil.verifyPassword(
          inputPassword: password,
          dbValue: passwordHash,
        );
        if (!isValid) {
          throw const ApiError(code: PASSWORD_INCORRECT);
        }
        final token = JwtUtil.generateJwt(user);
        final rToken = JwtUtil.generateRefeshJwt(user);
        return user.toEntity.copyWith(
          token: token,
          rToken: rToken,
        );
      },
    );
  }

  @override
  Future<Either<ApiError, bool>> signUp(
    String username,
    String password,
    String? fullName,
  ) async {
    final isTaken = await _userRepository.isUsernameOrEmailTaken(username, '');
    if (isTaken) {
      return const Either.left(ApiError(code: USERNAME_ALREADY_TAKEN));
    }
    if (!PasswordUtil.isValidPassword(password)) {
      return const Either.left(ApiError(
          code: PASSWORD_INCORRECT,
          message: 'Password does not meet complexity requirements.'));
    }
    final hashedPassword = PasswordUtil.generatePasswordHash(password);

    await _userRepository.createUser(
      username: username,
      password: hashedPassword,
      fullName: fullName,
    );
    return const Either.right(true);
  }
}
