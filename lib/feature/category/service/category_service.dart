import 'package:injectable/injectable.dart';
import 'package:mm/core/service/base_service.dart';
import 'package:mm/feature/category/dto/mapper.dart';
import 'package:mm/feature/category/dto/request/category_request_dto.dart';
import 'package:mm/feature/category/dto/response/category_response_dto.dart';
import 'package:mm/feature/category/entities/category_entity.dart';
import 'package:mm/feature/category/repository/category_repository.dart';

abstract base class CategoryService extends BaseService<CategoryEntity,
    CategoryRequestDto, CategoryResponseDto, CategoryRepository, CategoryMapper> {
  CategoryService(super.repository, super.mapper, super.connection);
}

@Injectable(as: CategoryService)
base class CategoryServiceImpl extends CategoryService {
  CategoryServiceImpl(super.repository, super.mapper, super.connection);
}