import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/request/request.dart';
import 'package:mm/feature/category/controller.dart';
import 'package:mm/feature/category/dto/mapper.dart';
import 'package:mm/feature/category/dto/request/category_request_dto.dart';
import 'package:mm/feature/category/dto/response/category_response_dto.dart';
import 'package:mm/feature/category/entities/category_entity.dart';
import 'package:mm/feature/category/repository/category_repository.dart';
import 'package:mm/feature/category/service/category_service.dart';

Future<Response> onRequest(RequestContext context) async {
  return requestWithOutId<CategoryEntity, CategoryRequestDto, CategoryResponseDto,
      CategoryRepository, CategoryMapper, CategoryService, CategoryController>(context);
}
