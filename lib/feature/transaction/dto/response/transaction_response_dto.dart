import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';

part 'transaction_response_dto.freezed.dart';

part 'transaction_response_dto.g.dart';

@freezed
abstract class TransactionResponseDto
    with _$TransactionResponseDto
    implements BaseResponseDto {
  const factory TransactionResponseDto({
    required int id,
  }) = _TransactionResponseDto;

  factory TransactionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseDtoFromJson(json);
}
