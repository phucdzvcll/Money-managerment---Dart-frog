import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/request/request.dart';
import 'package:mm/feature/account/controller.dart';
import 'package:mm/feature/account/dto/mapper.dart';
import 'package:mm/feature/account/dto/request/account_request_dto.dart';
import 'package:mm/feature/account/dto/response/account_response_dto.dart';
import 'package:mm/feature/account/entities/account_entity.dart';
import 'package:mm/feature/account/repository/account_repository.dart';
import 'package:mm/feature/account/service/account_service.dart';

Future<Response> onRequest(RequestContext context) async {
  return requestWithOutId<AccountEntity, AccountRequestDto, AccountResponseDto,
      AccountRepository, AccountMapper, AccountService, AccountController>(context);
}
