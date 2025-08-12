import 'package:mm/core/model/base_mapper.dart';
import 'package:mm/feature/category/dto/request/category_request_dto.dart';
import 'package:mm/feature/category/dto/response/category_response_dto.dart';
import 'package:mm/feature/category/entities/category_entity.dart';

class CategoryMapper extends BaseMapper<CategoryRequestDto, CategoryEntity,
    CategoryResponseDto> {
  @override
  CategoryEntity fromRequestDto(CategoryRequestDto dto) {
    return CategoryEntity(
      id: dto.id ?? '',
      userId: dto.userId ?? '',
      name: dto.name ?? '',
      kind: dto.kind ?? '',
      parentId: dto.parentId ?? '',
    );
  }

  @override
  CategoryResponseDto toResponseDto(CategoryEntity entity) {
    return CategoryResponseDto(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      kind: entity.kind,
      parentId: entity.parentId,
    );
  }
}
