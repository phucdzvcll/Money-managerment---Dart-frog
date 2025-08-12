import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/middleware/middleware.dart';
import 'package:mm/feature/account/controller.dart';
import 'package:mm/feature/account/dto/mapper.dart';
import 'package:mm/feature/account/dto/request/account_request_dto.dart';
import 'package:mm/feature/account/dto/response/account_response_dto.dart';
import 'package:mm/feature/account/entities/account_entity.dart';
import 'package:mm/feature/account/repository/account_repository.dart';
import 'package:mm/feature/account/service/account_service.dart';

Handler middleware(Handler handler) {
  return handler.use(
    featureMiddleware<AccountEntity, AccountRequestDto, AccountResponseDto,
        AccountRepository, AccountMapper, AccountService, AccountController>(
      AccountController.new,
      AccountServiceImpl.new,
      AccountRepositoryImpl.new,
      AccountMapper.new,
    ),
  );
}
