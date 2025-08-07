import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/request/request.dart';
import 'package:mm/feature/transaction/controller.dart';
import 'package:mm/feature/transaction/dto/mapper.dart';
import 'package:mm/feature/transaction/dto/request/transaction_request_dto.dart';
import 'package:mm/feature/transaction/dto/response/transaction_response_dto.dart';
import 'package:mm/feature/transaction/entities/transaction_entity.dart';
import 'package:mm/feature/transaction/repository/transaction_repository.dart';
import 'package:mm/feature/transaction/service/transaction_service.dart';

Future<Response> onRequest(RequestContext context) async {
  return requestWithOutId<
      TransactionEntity,
      TransactionRequestDto,
      TransactionResponseDto,
      TransactionRepository,
      TransactionMapper,
      TransactionService,
      TransactionController>(context);
}
