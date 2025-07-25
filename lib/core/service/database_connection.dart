import 'package:mm/constants/env.dart';
import 'package:postgres/postgres.dart';

Future<Connection> db() async => Connection.open(
      Endpoint(
        host: Env.dbHost,
        username: Env.dbUsername,
        password: Env.dbPassword,
        database: Env.dbDatabase,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
