import 'package:dart_frog/dart_frog.dart';
import 'package:mm/builder/anotation.dart';
import 'package:mm/core/controller/base_controller.dart';
import 'package:mm/feature/transaction/dto/mapper.dart';
import 'package:mm/feature/transaction/dto/request/transaction_request_dto.dart';
import 'package:mm/feature/transaction/dto/response/transaction_response_dto.dart';
import 'package:mm/feature/transaction/entities/transaction_entity.dart';
import 'package:mm/feature/transaction/repository/transaction_repository.dart';
import 'package:mm/feature/transaction/service/transaction_service.dart';

class TransactionController extends BaseController<
    TransactionEntity,
    TransactionRequestDto,
    TransactionResponseDto,
    TransactionMapper,
    TransactionRepository,
    TransactionService> {
  const TransactionController(super.service, super.userEntity);

  @override
  Future<TransactionRequestDto> body(RequestContext context) async {
    final json = await context.request.json() as Map<String, dynamic>;
    final dto = TransactionRequestDto.fromJson(json).copyWith();
    return dto;
  }

  @override
  @OpenApi(
    path: '/transaction/',
    method: 'POST',
    summary: 'Add new transaction ',
    tag: 'transaction',
    requestSchema: 'transaction_request_dto.openapi_schema.json',
    responseSchema: 'transaction_response_dto.openapi_schema.json',
  )
  Future<Response> executeCreate(TransactionRequestDto dto) async {
    return create(dto);
  }

  @override
  @OpenApi(
    path: '/transaction/',
    method: 'GET',
    summary: 'Find all transactions',
    tag: 'transaction',
    responseSchema: 'transaction_response_dto.openapi_schema.json',
    isList: true,
  )
  Future<Response> executeFindAll() {
    return findAll();
  }

  @override
  @OpenApi(
    path: '/transaction/',
    method: 'PUT',
    summary: 'update transaction ',
    tag: 'transaction',
    responseSchema: 'transaction_response_dto.openapi_schema.json',
  )
  Future<Response> executeUpdate(TransactionRequestDto dto) async {
    return update(dto);
  }

  @override
  @OpenApi(
    path: '/transaction/{id}',
    method: 'GET',
    summary: 'Find transaction by id',
    tag: 'transaction',
    responseSchema: 'transaction_response_dto.openapi_schema.json',
    isPath: true,
  )
  Future<Response> executeFindById({required int id}) {
    return findById(id);
  }

  @override
  @OpenApi(
    path: '/transaction/{id}',
    method: 'DELETE',
    summary: 'Delete transaction by id',
    tag: 'transaction',
    isPath: true,
  )
  Future<Response> executeDeleteById({required int id}) async {
    return delete(id);
  }
}
