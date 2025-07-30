import 'package:injectable/injectable.dart';
import 'package:mm/core/service/base_service.dart';
import 'package:mm/feature/credit/dto/mapper.dart';
import 'package:mm/feature/credit/dto/req/credit_request_dto.dart';
import 'package:mm/feature/credit/dto/res/credit_response_dto.dart';
import 'package:mm/feature/credit/entities/credit_entity.dart';
import 'package:mm/feature/credit/repository/credit_repository.dart';

abstract base class CreditService extends BaseService<CreditEntity,
    CreditRequestDto, CreditResponseDto, CreditRepository, CreditMapper> {
  CreditService(super.repository, super.mapper, super.connection);
}

@Injectable(as: CreditService)
base class CreditServiceImpl extends CreditService {
  CreditServiceImpl(super.repository, super.mapper, super.connection);
}
