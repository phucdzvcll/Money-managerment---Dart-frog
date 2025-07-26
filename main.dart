import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/service/database_connection.dart';
import 'package:postgres/postgres.dart';

late Connection connection;

Future<void> init(InternetAddress ip, int port) async {
  connection = await db();
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port)  {
  final mdw = provider<Connection>((ctx) => connection);
  return serve(handler.use(mdw), ip, port);
}
