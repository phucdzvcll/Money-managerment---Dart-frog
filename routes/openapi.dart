import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final file = File('openapi.yaml');
  if (!await file.exists()) {
    return Response(statusCode: 404, body: 'OpenAPI spec not found');
  }
  final yaml = await file.readAsString();
  return Response(body: yaml, headers: {'content-type': 'text/yaml'});
}

