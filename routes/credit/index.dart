import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/request/request.dart';
import 'package:mm/feature/credit/controller.dart';
import 'package:mm/feature/credit/dto/mapper.dart';
import 'package:mm/feature/credit/dto/req/credit_request_dto.dart';
import 'package:mm/feature/credit/dto/res/credit_response_dto.dart';
import 'package:mm/feature/credit/entities/credit_entity.dart';
import 'package:mm/feature/credit/repository/credit_repository.dart';
import 'package:mm/feature/credit/service/credit_service.dart';

Future<Response> onRequest(RequestContext context) async {
  return requestWithOutId<CreditEntity, CreditRequestDto, CreditResponseDto,
      CreditRepository, CreditMapper, CreditService, CreditController>(context);
}
