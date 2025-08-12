import 'package:mm/core/model/base_mapper.dart';
import 'package:mm/feature/account/dto/request/account_request_dto.dart';
import 'package:mm/feature/account/dto/response/account_response_dto.dart';
import 'package:mm/feature/account/entities/account_entity.dart';

class AccountMapper
    extends BaseMapper<AccountRequestDto, AccountEntity, AccountResponseDto> {
  @override
  AccountEntity fromRequestDto(AccountRequestDto dto) {
    return AccountEntity(
      id: dto.id ?? '',
      userId: dto.userId ?? '',
      type: dto.type ?? '',
      name: dto.name ?? '',
      issuer: dto.issuer ?? '',
      note: dto.note ?? '',
      isArchived: dto.isArchived ?? false,
      deletedAt: dto.deletedAt ?? '',
    );
  }

  @override
  AccountResponseDto toResponseDto(AccountEntity entity) {
    return AccountResponseDto(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      name: entity.name,
      issuer: entity.issuer,
      note: entity.note,
      isArchived: entity.isArchived,
      deletedAt: entity.deletedAt,
    );
  }
}
