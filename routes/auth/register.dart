import 'package:dart_frog/dart_frog.dart';
import 'package:mm/feature/auth/controller.dart' as auth_controller;

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;
  switch (method) {
    case HttpMethod.post:
      return auth_controller.registerRequest(context);
    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: 405, body: 'Method Not Allowed');
  }
}
