import 'package:dart_frog/dart_frog.dart';
import 'package:mm/builder/anotation.dart';
import 'package:mm/core/controller/base_controller.dart';
import 'package:mm/feature/account/dto/mapper.dart';
import 'package:mm/feature/account/dto/request/account_request_dto.dart';
import 'package:mm/feature/account/dto/response/account_response_dto.dart';
import 'package:mm/feature/account/entities/account_entity.dart';
import 'package:mm/feature/account/repository/account_repository.dart';
import 'package:mm/feature/account/service/account_service.dart';

class AccountController extends BaseController<AccountEntity, AccountRequestDto,
    AccountResponseDto, AccountMapper, AccountRepository, AccountService> {
  const AccountController(super.service, super.userEntity);

  @override
  Future<AccountRequestDto> body(RequestContext context) async {
    final json = await context.request.json() as Map<String, dynamic>;
    final dto = AccountRequestDto.fromJson(json).copyWith();
    return dto;
  }

  @override
  @OpenApi(
    path: '/account/',
    method: 'POST',
    summary: 'Add new account ',
    tag: 'account',
    requestSchema: 'account_request_dto.openapi_schema.json',
    responseSchema: 'account_response_dto.openapi_schema.json',
  )
  Future<Response> executeCreate(AccountRequestDto dto) async {
    return create(dto);
  }

  @override
  @OpenApi(
    path: '/account/',
    method: 'GET',
    summary: 'Find all accounts',
    tag: 'account',
    responseSchema: 'account_response_dto.openapi_schema.json',
    isList: true,
  )
  Future<Response> executeFindAll() {
    return findAll();
  }

  @override
  @OpenApi(
    path: '/account/',
    method: 'PUT',
    summary: 'update account ',
    tag: 'account',
    responseSchema: 'account_response_dto.openapi_schema.json',
  )
  Future<Response> executeUpdate(AccountRequestDto dto) async {
    return update(dto);
  }

  @override
  @OpenApi(
    path: '/account/{id}',
    method: 'GET',
    summary: 'Find account by id',
    tag: 'account',
    responseSchema: 'account_response_dto.openapi_schema.json',
    isPath: true,
  )
  Future<Response> executeFindById({required String id}) {
    return findById(id);
  }

  @override
  @OpenApi(
    path: '/account/{id}',
    method: 'DELETE',
    summary: 'Delete account by id',
    tag: 'account',
    isPath: true,
  )
  Future<Response> executeDeleteById({required String   id}) async {
    return delete(id);
  }
}
