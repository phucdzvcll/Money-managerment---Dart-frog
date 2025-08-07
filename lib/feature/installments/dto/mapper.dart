import 'package:mm/core/model/base_mapper.dart';
import 'package:mm/feature/installments/dto/request/installments_request_dto.dart';
import 'package:mm/feature/installments/dto/response/installments_response_dto.dart';
import 'package:mm/feature/installments/entities/installments_entity.dart';

class InstallmentsMapper extends BaseMapper<InstallmentsRequestDto,
    InstallmentsEntity, InstallmentsResponseDto> {
  @override
  InstallmentsEntity fromRequestDto(InstallmentsRequestDto dto) {
    return InstallmentsEntity(
      id: dto.id ?? 0,
      userId: dto.userId ?? 0,
      name: dto.name ?? '',
      totalAmount: dto.totalAmount ?? 0,
      monthlyAmount: dto.monthlyAmount ?? 0,
      startDate: dto.startDate ?? '',
      months: dto.months ?? 0,
      isCompleted: dto.isCompleted ?? false,
      creditId: dto.creditId ?? 0,
    );
  }

  @override
  InstallmentsResponseDto toResponseDto(InstallmentsEntity entity) {
    return InstallmentsResponseDto(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      totalAmount: entity.totalAmount,
      monthlyAmount: entity.monthlyAmount,
      startDate: entity.startDate,
      months: entity.months,
      isCompleted: entity.isCompleted,
      creditId: entity.creditId,
    );
  }
}
