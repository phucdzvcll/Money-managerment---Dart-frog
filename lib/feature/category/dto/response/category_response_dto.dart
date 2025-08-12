import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';
part 'category_response_dto.freezed.dart';
part 'category_response_dto.g.dart';

@freezed
abstract class CategoryResponseDto with _$CategoryResponseDto implements BaseResponseDto{
const factory CategoryResponseDto({
   String? id,
 @JsonKey(name:'user_id')  String? userId,
   String? name,
   String? kind,
 @JsonKey(name:'parent_id')  String? parentId,
 @JsonKey(name:'created_at')  String? createdAt,
 @JsonKey(name:'updated_at')  String? updatedAt,
 @JsonKey(name:'deleted_at')  String? deletedAt,

          }) = _CategoryResponseDto;

factory CategoryResponseDto.fromJson(Map<String, dynamic> json) => _$CategoryResponseDtoFromJson(json);
}