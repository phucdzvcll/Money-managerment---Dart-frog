import 'package:dart_frog/dart_frog.dart';
import 'package:mm/feature/credit/controller.dart' as credit_controller;

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;
  switch (method) {
    case HttpMethod.post:
      return credit_controller.onGetAllCredits(context);
    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: 405, body: 'Method Not Allowed');
  }
}
