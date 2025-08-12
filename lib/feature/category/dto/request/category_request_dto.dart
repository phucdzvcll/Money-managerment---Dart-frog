import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';
part 'category_request_dto.freezed.dart';
part 'category_request_dto.g.dart';

@freezed
abstract class CategoryRequestDto with _$CategoryRequestDto implements BaseRequestDto{
const factory CategoryRequestDto({
   String? id,
 @JsonKey(name:'user_id')  String? userId,
   String? name,
   String? kind,
 @JsonKey(name:'parent_id')  String? parentId,
 @JsonKey(name:'created_at')  String? createdAt,
 @JsonKey(name:'updated_at')  String? updatedAt,
 @JsonKey(name:'deleted_at')  String? deletedAt,

          }) = _CategoryRequestDto;

factory CategoryRequestDto.fromJson(Map<String, dynamic> json) => _$CategoryRequestDtoFromJson(json);
}