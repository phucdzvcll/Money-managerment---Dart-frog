import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';

part 'transaction_request_dto.freezed.dart';

part 'transaction_request_dto.g.dart';

@freezed
abstract class TransactionRequestDto
    with _$TransactionRequestDto
    implements BaseRequestDto {
  const factory TransactionRequestDto({
    required int id,
  }) = _TransactionRequestDto;

  factory TransactionRequestDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestDtoFromJson(json);
}
