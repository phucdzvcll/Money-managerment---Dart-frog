import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/builder/anotation.dart';
import 'package:mm/core/model/base_dto.dart';

part 'credit_request_dto.freezed.dart';
part 'credit_request_dto.g.dart';

@OpenApiSchema()
@freezed
abstract class CreditRequestDto
    with _$CreditRequestDto
    implements BaseRequestDto {
  const factory CreditRequestDto({
    int? id,
    @FieldIgnore() @JsonKey(name: 'user_id') int? userId,
    String? source,
    @JsonKey(name: 'limit_amount')
    double? limitAmount,
    @JsonKey(name: 'due_date') String? dueDate,
    @JsonKey(name: 'statement_date') String? statementDate,
  }) = _CreditRequestDto;

  factory CreditRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreditRequestDtoFromJson(json);
}
