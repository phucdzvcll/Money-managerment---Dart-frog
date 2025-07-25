import 'package:conduit_password_hash/pbkdf2.dart';
import 'package:conduit_password_hash/salt.dart' as Salt;

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
    final salt = Salt.generateAsBase64String(32);
    final hashed =
        _generator.generateBase64Key(password, salt, _iterations, _hashLength);
    return '$salt:$hashed';
  }

  static bool verifyPassword(String inputPassword, String storedSaltAndHash) {
    final parts = storedSaltAndHash.split(':');
    if (parts.length != 2) return false;

    final salt = parts[0];
    final storedHash = parts[1];

    final inputHash = _generator.generateBase64Key(
        inputPassword, salt, _iterations, _hashLength);

    return inputHash == storedHash;
  }
}
