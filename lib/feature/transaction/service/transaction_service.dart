import 'package:injectable/injectable.dart';
import 'package:mm/core/service/base_service.dart';
import 'package:mm/feature/transaction/dto/mapper.dart';
import 'package:mm/feature/transaction/dto/request/transaction_request_dto.dart';
import 'package:mm/feature/transaction/dto/response/transaction_response_dto.dart';
import 'package:mm/feature/transaction/entities/transaction_entity.dart';
import 'package:mm/feature/transaction/repository/transaction_repository.dart';

abstract base class TransactionService extends BaseService<
    TransactionEntity,
    TransactionRequestDto,
    TransactionResponseDto,
    TransactionRepository,
    TransactionMapper> {
  TransactionService(super.repository, super.mapper, super.connection);
}

@Injectable(as: TransactionService)
base class TransactionServiceImpl extends TransactionService {
  TransactionServiceImpl(super.repository, super.mapper, super.connection);
}
