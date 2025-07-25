import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'DB_HOST')
  static const String dbHost = _Env.dbHost;

  @EnviedField(varName: 'DB_USERNAME')
  static const String dbUsername = _Env.dbUsername;

  @EnviedField(varName: 'DB_PASSWORD')
  static const String dbPassword = _Env.dbPassword;

  @EnviedField(varName: 'DB_DATABASE')
  static const String dbDatabase = _Env.dbDatabase;

  @EnviedField(varName: 'JWT_ACCESS_SECRET')
  static const String jwtAccessSecret = _Env.jwtAccessSecret;

  @EnviedField(varName: 'JWT_REFRESH_SECRET')
  static const String jwtRefreshSecret = _Env.jwtRefreshSecret;
}