import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/middleware/middleware.dart';
import 'package:mm/feature/category/controller.dart';
import 'package:mm/feature/category/dto/mapper.dart';
import 'package:mm/feature/category/dto/request/category_request_dto.dart';
import 'package:mm/feature/category/dto/response/category_response_dto.dart';
import 'package:mm/feature/category/entities/category_entity.dart';
import 'package:mm/feature/category/repository/category_repository.dart';
import 'package:mm/feature/category/service/category_service.dart';

Handler middleware(Handler handler) {
  return handler.use(
    featureMiddleware<CategoryEntity, CategoryRequestDto, CategoryResponseDto,
        CategoryRepository, CategoryMapper, CategoryService, CategoryController>(
      CategoryController.new,
      CategoryServiceImpl.new,
      CategoryRepositoryImpl.new,
      CategoryMapper.new,
    ),
  );
}
