import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';

part 'credit_dto.freezed.dart';

part 'credit_dto.g.dart';

@freezed
abstract class CreditDto with _$CreditDto implements BaseDto {
  const factory CreditDto({
    int? id,
    required int userId,
    required String source,
    required double limitAmount,
    required double usedAmount,
    DateTime? dueDate,
    double? interestRate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CreditDto;

  factory CreditDto.fromJson(Map<String, dynamic> json) =>
      _$CreditDtoFromJson(json);
}
