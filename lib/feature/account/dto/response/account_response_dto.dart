import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';
part 'account_response_dto.freezed.dart';
part 'account_response_dto.g.dart';

@freezed
abstract class AccountResponseDto with _$AccountResponseDto implements BaseResponseDto{
const factory AccountResponseDto({
   String? id,
 @JsonKey(name:'user_id')  String? userId,
   String? type,
   String? name,
   String? issuer,
   String? note,
 @JsonKey(name:'is_archived')  bool? isArchived,
 @JsonKey(name:'deleted_at')  String? deletedAt,
 @JsonKey(name:'created_at')  String? createdAt,
 @JsonKey(name:'updated_at')  String? updatedAt,

          }) = _AccountResponseDto;

factory AccountResponseDto.fromJson(Map<String, dynamic> json) => _$AccountResponseDtoFromJson(json);
}