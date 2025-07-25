import 'package:mm/constants/env.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mm/models/user_dto.dart';

class JwtUtil {
  static final _assetsTokenKey = SecretKey(Env.jwtAccessSecret);
  static final _refeshTokenKey = SecretKey(Env.jwtRefreshSecret);

  static String generateJwt(UserDto user) {
    final jwt = JWT(
      {
        'username': user.username,
        'full_name': user.fullName,
      },
      issuer: 'mm',
    );
    return jwt.sign(_assetsTokenKey, expiresIn: const Duration(days: 1));
  }

  static String generateRefeshJwt(UserDto user) {
    final jwt = JWT(
      {
        'username': user.username,
        'full_name': user.fullName,
      },
      issuer: 'mm',
    );
    return jwt.sign(_refeshTokenKey, expiresIn: const Duration(days: 30));
  }

  static bool verifyJwt(String token) {
    try {
      JWT.verify(token, _assetsTokenKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool verifyRefreshJwt(String token) {
    try {
      JWT.verify(token, _refeshTokenKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
