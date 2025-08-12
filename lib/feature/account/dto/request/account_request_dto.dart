import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';
part 'account_request_dto.freezed.dart';
part 'account_request_dto.g.dart';

@freezed
abstract class AccountRequestDto with _$AccountRequestDto implements BaseRequestDto{
const factory AccountRequestDto({
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

          }) = _AccountRequestDto;

factory AccountRequestDto.fromJson(Map<String, dynamic> json) => _$AccountRequestDtoFromJson(json);
}