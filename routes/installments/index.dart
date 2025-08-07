import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/request/request.dart';
import 'package:mm/feature/installments/controller.dart';
import 'package:mm/feature/installments/dto/mapper.dart';
import 'package:mm/feature/installments/dto/request/installments_request_dto.dart';
import 'package:mm/feature/installments/dto/response/installments_response_dto.dart';
import 'package:mm/feature/installments/entities/installments_entity.dart';
import 'package:mm/feature/installments/repository/installments_repository.dart';
import 'package:mm/feature/installments/service/installments_service.dart';

Future<Response> onRequest(RequestContext context) async {
  return requestWithOutId<InstallmentsEntity, InstallmentsRequestDto, InstallmentsResponseDto,
      InstallmentsRepository, InstallmentsMapper, InstallmentsService, InstallmentsController>(context);
}
