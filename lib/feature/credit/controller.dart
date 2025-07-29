import 'package:dart_frog/dart_frog.dart';
import 'package:mm/builder/anotation.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/feature/credit/service/credit_service.dart';

@OpenApi(
  path: '/credit/credits',
  method: 'GET',
  summary: 'Find all credits card',
  tag: 'credit',
  requestSchema: '',
  responseSchema: 'credit_dto.openapi_schema.json',
)
Future<Response> onGetAllCredits(RequestContext context) async {
  final creditService = context.read<CreditService>();

  final result = await creditService.excuteGetAll((e) {
    return e.toString();
  });
  return result.fold(
    ifLeft: (ApiError e) {
      final error = ErrorResponse(error: e, code: 400);
      return error.toResponse();
    },
    ifRight: (r) {
      return Response.json(
        statusCode: 200,
        body: r,
      );
    },
  );
}
