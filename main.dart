import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/service/database_connection.dart';
import 'package:postgres/postgres.dart';

late Connection _connection;

Future<void> init(InternetAddress ip, int port) async {
  _connection = await db();
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  final mdw = provider<Connection>((ctx) => _connection);
  return serve(handler.use(mdw), ip, port);
}
