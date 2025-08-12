import 'package:mm/constants/env.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mm/feature/auth/entities/user_entity.dart';

class JwtUtil {
  static final _assetsTokenKey = SecretKey(Env.jwtAccessSecret);
  static final _refeshTokenKey = SecretKey(Env.jwtRefreshSecret);

  static UserEntity decodeJwt(String token) {
    try {
      final jwt = JWT.verify(token, _assetsTokenKey);
      final payload = jwt.payload;
      return UserEntity(
        id: payload['id'] as String,
        passwordHash: payload['password_hash'] as String,
        username: payload['username'] as String,
        fullName: payload['full_name'] as String?,
      );
    } catch (e) {
      throw Exception('Invalid JWT: $e');
    }
  }

  static String generateJwt(UserEntity user) {
    final jwt = JWT(
      user.toJson(),
      issuer: 'mm',
    );
    return jwt.sign(_assetsTokenKey, expiresIn: const Duration(days: 1));
  }

  static String generateRefeshJwt(UserEntity user) {
    final jwt = JWT(
      user.toJson(),
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
