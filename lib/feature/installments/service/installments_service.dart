import 'package:injectable/injectable.dart';
import 'package:mm/core/service/base_service.dart';
import 'package:mm/feature/installments/dto/mapper.dart';
import 'package:mm/feature/installments/dto/request/installments_request_dto.dart';
import 'package:mm/feature/installments/dto/response/installments_response_dto.dart';
import 'package:mm/feature/installments/entities/installments_entity.dart';
import 'package:mm/feature/installments/repository/installments_repository.dart';

abstract base class InstallmentsService extends BaseService<InstallmentsEntity,
    InstallmentsRequestDto, InstallmentsResponseDto, InstallmentsRepository, InstallmentsMapper> {
  InstallmentsService(super.repository, super.mapper, super.connection);
}

@Injectable(as: InstallmentsService)
base class InstallmentsServiceImpl extends InstallmentsService {
  InstallmentsServiceImpl(super.repository, super.mapper, super.connection);
}