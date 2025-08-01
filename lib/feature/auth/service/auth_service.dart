import 'package:dart_either/dart_either.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/core/service/service_mixin.dart';
import 'package:mm/core/utils/auth/jwt.dart';
import 'package:mm/core/utils/auth/password_util.dart';
import 'package:mm/feature/auth/dto/request/login_request_dto.dart';
import 'package:mm/feature/auth/dto/response/login_response.dart';
import 'package:mm/feature/auth/repository/user_repository.dart';

abstract class AuthService {
  Future<Either<ApiError, LoginResponse>> login(LoginRequestDto dto);

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
  Future<Either<ApiError, LoginResponse>> login(LoginRequestDto dto) async {
    return call(
      mapper: (LoginResponse e) => e,
      fn: () async {
        final user = await _userRepository.getUserByUsername(dto.username);

        final passwordHash = user.passwordHash;
        final isValid = PasswordUtil.verifyPassword(
          inputPassword: dto.password,
          dbValue: passwordHash,
        );
        if (!isValid) {
          throw const ApiError(code: PASSWORD_INCORRECT, statusCode: 400);
        }
        final token = JwtUtil.generateJwt(user);
        final rToken = JwtUtil.generateRefeshJwt(user);

        return LoginResponse(
            userId: user.id,
            username: user.username,
            token: token,
            rToken: rToken);
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
      return const Either.left(
          ApiError(code: USERNAME_ALREADY_TAKEN, statusCode: 400));
    }
    if (!PasswordUtil.isValidPassword(password)) {
      return const Either.left(
        ApiError(
          code: PASSWORD_INCORRECT,
          message: 'Password does not meet complexity requirements.',
          statusCode: 400,
        ),
      );
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
