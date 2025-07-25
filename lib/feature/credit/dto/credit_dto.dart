import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';

part 'credit_dto.freezed.dart';

part 'credit_dto.g.dart';

@freezed
abstract class CreditDto with _$CreditDto implements BaseDto {
  const factory CreditDto({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String source,
    @JsonKey(name: 'limit_amount') required double limitAmount,
    @JsonKey(name: 'due_date') required String dueDate,
    @JsonKey(name: 'statement_date') required String statementDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CreditDto;

  factory CreditDto.fromJson(Map<String, dynamic> json) =>
      _$CreditDtoFromJson(json);
}
