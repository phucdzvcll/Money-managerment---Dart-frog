import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_entity.dart';

part 'category_entity.freezed.dart';

part 'category_entity.g.dart';

@freezed
abstract class CategoryEntity with _$CategoryEntity implements BaseEntity {
  const factory CategoryEntity({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    required String kind,
    @JsonKey(name: 'parent_id') required String parentId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CategoryEntity;

  factory CategoryEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryEntityFromJson(json);
}
