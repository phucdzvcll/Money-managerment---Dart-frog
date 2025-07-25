import 'package:conduit_password_hash/pbkdf2.dart';
import 'package:mm/constants/env.dart';

class PasswordUtil {
  /// Validates if the given password meets the criteria:
  /// - At least 8 characters long
  /// - Contains at least one uppercase letter
  /// - Contains at least one lowercase letter
  /// - Contains at least one digit
  /// - Contains at least one special character
  static bool isValidPassword(String password) {
    final RegExp passwordPattern = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordPattern.hasMatch(password);
  }

  static final _generator = PBKDF2();
  static const _iterations = 500;
  static const _hashLength = 16;

  static String generatePasswordHash(String password) {
    final hashed = _generator.generateBase64Key(
        password, Env.passwordSaltKey, _iterations, _hashLength);
    return '${Env.passwordSaltKey}:$hashed';
  }

  static bool verifyPassword({
    required String inputPassword,
    required String dbValue,
  }) {
    final pass = generatePasswordHash(inputPassword);
    return pass == dbValue;
  }
}
