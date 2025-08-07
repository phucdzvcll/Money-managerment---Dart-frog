import 'package:dart_frog/dart_frog.dart';
import 'package:mm/builder/anotation.dart';
import 'package:mm/core/controller/base_controller.dart';
import 'package:mm/feature/installments/dto/mapper.dart';
import 'package:mm/feature/installments/dto/request/installments_request_dto.dart';
import 'package:mm/feature/installments/dto/response/installments_response_dto.dart';
import 'package:mm/feature/installments/entities/installments_entity.dart';
import 'package:mm/feature/installments/repository/installments_repository.dart';
import 'package:mm/feature/installments/service/installments_service.dart';

class InstallmentsController extends BaseController<InstallmentsEntity, InstallmentsRequestDto,
    InstallmentsResponseDto, InstallmentsMapper, InstallmentsRepository, InstallmentsService> {
  const InstallmentsController(super.service, super.userEntity);

  @override
  Future<InstallmentsRequestDto> body(RequestContext context) async {
    final json = await context.request.json() as Map<String, dynamic>;
    final dto = InstallmentsRequestDto.fromJson(json).copyWith();
    return dto;
  }

  @override
  @OpenApi(
    path: '/installments/',
    method: 'POST',
    summary: 'Add new installments ',
    tag: 'installments',
    requestSchema: 'installments_request_dto.openapi_schema.json',
    responseSchema: 'installments_response_dto.openapi_schema.json',
  )
  Future<Response> executeCreate(InstallmentsRequestDto dto) async {
    return create(dto);
  }

  @override
  @OpenApi(
    path: '/installments/',
    method: 'GET',
    summary: 'Find all installmentss',
    tag: 'installments',
    responseSchema: 'installments_response_dto.openapi_schema.json',
    isList: true,
  )
  Future<Response> executeFindAll() {
    return findAll();
  }

  @override
  @OpenApi(
    path: '/installments/',
    method: 'PUT',
    summary: 'update installments ',
    tag: 'installments',
    responseSchema: 'installments_response_dto.openapi_schema.json',
  )
  Future<Response> executeUpdate(InstallmentsRequestDto dto) async {
    return update(dto);
  }

  @override
  @OpenApi(
    path: '/installments/{id}',
    method: 'GET',
    summary: 'Find installments by id',
    tag: 'installments',
    responseSchema: 'installments_response_dto.openapi_schema.json',
    isPath: true,
  )
  Future<Response> executeFindById({required int id}) {
    return findById(id);
  }

  @override
  @OpenApi(
    path: '/installments/{id}',
    method: 'DELETE',
    summary: 'Delete installments by id',
    tag: 'installments',
    isPath: true,
  )
  Future<Response> executeDeleteById({required int id}) async {
    return delete(id);
  }
}
