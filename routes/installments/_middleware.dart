import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/middleware/middleware.dart';
import 'package:mm/feature/installments/controller.dart';
import 'package:mm/feature/installments/dto/mapper.dart';
import 'package:mm/feature/installments/dto/request/installments_request_dto.dart';
import 'package:mm/feature/installments/dto/response/installments_response_dto.dart';
import 'package:mm/feature/installments/entities/installments_entity.dart';
import 'package:mm/feature/installments/repository/installments_repository.dart';
import 'package:mm/feature/installments/service/installments_service.dart';

Handler middleware(Handler handler) {
  return handler.use(
    featureMiddleware<InstallmentsEntity, InstallmentsRequestDto, InstallmentsResponseDto,
        InstallmentsRepository, InstallmentsMapper, InstallmentsService, InstallmentsController>(
      InstallmentsController.new,
      InstallmentsServiceImpl.new,
      InstallmentsRepositoryImpl.new,
      InstallmentsMapper.new,
    ),
  );
}
