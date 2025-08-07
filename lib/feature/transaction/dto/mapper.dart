import 'package:mm/core/model/base_mapper.dart';
import 'package:mm/feature/transaction/dto/request/transaction_request_dto.dart';
import 'package:mm/feature/transaction/dto/response/transaction_response_dto.dart';
import 'package:mm/feature/transaction/entities/transaction_entity.dart';

class TransactionMapper extends BaseMapper<TransactionRequestDto,
    TransactionEntity, TransactionResponseDto> {
  @override
  TransactionEntity fromRequestDto(TransactionRequestDto dto) {
    return TransactionEntity(id: dto.id);
  }

  @override
  TransactionResponseDto toResponseDto(TransactionEntity entity) {
    return TransactionResponseDto(id: entity.id);
  }
}
