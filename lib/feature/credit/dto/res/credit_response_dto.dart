import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/builder/anotation.dart';
import 'package:mm/core/model/base_dto.dart';

part 'credit_response_dto.freezed.dart';
part 'credit_response_dto.g.dart';

@OpenApiSchema()
@freezed
abstract class CreditResponseDto
    with _$CreditResponseDto
    implements BaseResponseDto {
  const factory CreditResponseDto({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String source,
    @JsonKey(name: 'limit_amount') required double limitAmount,
    @JsonKey(name: 'due_date') required String dueDate,
    @JsonKey(name: 'statement_date') required String statementDate,
  }) = _CreditResponseDto;

  factory CreditResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreditResponseDtoFromJson(json);
}
