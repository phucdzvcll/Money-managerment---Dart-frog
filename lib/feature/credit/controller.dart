import 'package:dart_frog/dart_frog.dart';
import 'package:mm/builder/anotation.dart';
import 'package:mm/core/controller/base_controller.dart';
import 'package:mm/feature/credit/dto/mapper.dart';
import 'package:mm/feature/credit/dto/req/credit_request_dto.dart';
import 'package:mm/feature/credit/dto/res/credit_response_dto.dart';
import 'package:mm/feature/credit/entities/credit_entity.dart';
import 'package:mm/feature/credit/repository/credit_repository.dart';
import 'package:mm/feature/credit/service/credit_service.dart';

class CreditController extends BaseController<CreditEntity, CreditRequestDto,
    CreditResponseDto, CreditMapper, CreditRepository, CreditService> {
  const CreditController(super.service, super.userEntity);

  @override
  Future<CreditRequestDto> body(RequestContext context) async {
    final json = await context.request.json() as Map<String, dynamic>;
    final dto = CreditRequestDto.fromJson(json).copyWith(userId: userEntity.id);
    return dto;
  }

  @override
  @OpenApi(
    path: '/credit/',
    method: 'POST',
    summary: 'Add new credit card',
    tag: 'credit',
    requestSchema: 'credit_request_dto.openapi_schema.json',
    responseSchema: 'credit_response_dto.openapi_schema.json',
  )
  Future<Response> executeCreate(CreditRequestDto dto) async {
    return create(dto);
  }

  @override
  @OpenApi(
    path: '/credit/',
    method: 'GET',
    summary: 'Find all credit cards',
    tag: 'credit',
    responseSchema: 'credit_response_dto.openapi_schema.json',
    isList: true,
  )
  Future<Response> executeFindAll() {
    return findAll();
  }

  @override
  @OpenApi(
    path: '/credit/',
    method: 'PUT',
    summary: 'update credit card',
    tag: 'credit',
    responseSchema: 'credit_response_dto.openapi_schema.json',
  )
  Future<Response> executeUpdate(CreditRequestDto dto) async {
    return update(dto);
  }

  @override
  @OpenApi(
    path: '/credit/{id}',
    method: 'GET',
    summary: 'Find credit card by id',
    tag: 'credit',
    responseSchema: 'credit_response_dto.openapi_schema.json',
    isPath: true,
  )
  Future<Response> executeFindById({required int id}) {
    return findById(id);
  }

  @override
  @OpenApi(
    path: '/credit/{id}',
    method: 'DELETE',
    summary: 'Delete credit card by id',
    tag: 'credit',
    isPath: true,
  )
  Future<Response> executeDeleteById({required int id}) async {
    return delete(id);
  }
}
