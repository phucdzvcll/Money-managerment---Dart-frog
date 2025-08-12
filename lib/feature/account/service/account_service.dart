import 'package:injectable/injectable.dart';
import 'package:mm/core/service/base_service.dart';
import 'package:mm/feature/account/dto/mapper.dart';
import 'package:mm/feature/account/dto/request/account_request_dto.dart';
import 'package:mm/feature/account/dto/response/account_response_dto.dart';
import 'package:mm/feature/account/entities/account_entity.dart';
import 'package:mm/feature/account/repository/account_repository.dart';

abstract base class AccountService extends BaseService<AccountEntity,
    AccountRequestDto, AccountResponseDto, AccountRepository, AccountMapper> {
  AccountService(super.repository, super.mapper, super.connection);
}

@Injectable(as: AccountService)
base class AccountServiceImpl extends AccountService {
  AccountServiceImpl(super.repository, super.mapper, super.connection);
}