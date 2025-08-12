import 'package:mm/core/model/base_mapper.dart';
import 'package:mm/feature/credit/dto/req/credit_request_dto.dart';
import 'package:mm/feature/credit/dto/res/credit_response_dto.dart';
import 'package:mm/feature/credit/entities/credit_entity.dart';

class CreditMapper
    extends BaseMapper<CreditRequestDto, CreditEntity, CreditResponseDto> {
  @override
  CreditEntity fromRequestDto(CreditRequestDto dto) {
    return CreditEntity(
      id: dto.id ?? '',
      userId: dto.userId ?? '',
      source: dto.source ?? '',
      limitAmount: dto.limitAmount ?? 0.0,
      dueDate: dto.dueDate ?? '',
      statementDate: dto.statementDate ?? '',
    );
  }

  @override
  CreditResponseDto toResponseDto(CreditEntity entity) {
    return CreditResponseDto(
      id: entity.id,
      userId: entity.userId,
      source: entity.source,
      limitAmount: entity.limitAmount,
      dueDate: entity.dueDate,
      statementDate: entity.statementDate,
    );
  }
}
