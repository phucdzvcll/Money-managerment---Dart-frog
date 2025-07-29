import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final file = File('lib/openapi.json');
  if (!await file.exists()) {
    return Response(statusCode: 404, body: 'OpenAPI spec not found');
  }
  final json = await file.readAsString();
  return Response(body: json, headers: {'content-type': 'application/json'});
}

