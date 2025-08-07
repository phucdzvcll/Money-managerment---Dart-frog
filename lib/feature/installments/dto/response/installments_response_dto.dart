import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';

part 'installments_response_dto.freezed.dart';

part 'installments_response_dto.g.dart';

@freezed
abstract class InstallmentsResponseDto
    with _$InstallmentsResponseDto
    implements BaseResponseDto {
  const factory InstallmentsResponseDto({
    int? id,
    @JsonKey(name: 'user_id') int? userId,
    String? name,
    @JsonKey(name: 'total_amount') double? totalAmount,
    @JsonKey(name: 'monthly_amount') double? monthlyAmount,
    @JsonKey(name: 'start_date') String? startDate,
    int? months,
    @JsonKey(name: 'is_completed') bool? isCompleted,
    @JsonKey(name: 'credit_id') int? creditId,
  }) = _InstallmentsResponseDto;

  factory InstallmentsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$InstallmentsResponseDtoFromJson(json);
}
