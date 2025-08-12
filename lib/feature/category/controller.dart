import 'package:dart_frog/dart_frog.dart';
import 'package:mm/builder/anotation.dart';
import 'package:mm/core/controller/base_controller.dart';
import 'package:mm/feature/category/dto/mapper.dart';
import 'package:mm/feature/category/dto/request/category_request_dto.dart';
import 'package:mm/feature/category/dto/response/category_response_dto.dart';
import 'package:mm/feature/category/entities/category_entity.dart';
import 'package:mm/feature/category/repository/category_repository.dart';
import 'package:mm/feature/category/service/category_service.dart';

class CategoryController extends BaseController<
    CategoryEntity,
    CategoryRequestDto,
    CategoryResponseDto,
    CategoryMapper,
    CategoryRepository,
    CategoryService> {
  const CategoryController(super.service, super.userEntity);

  @override
  Future<CategoryRequestDto> body(RequestContext context) async {
    final json = await context.request.json() as Map<String, dynamic>;
    final dto = CategoryRequestDto.fromJson(json).copyWith();
    return dto;
  }

  @override
  @OpenApi(
    path: '/category/',
    method: 'POST',
    summary: 'Add new category ',
    tag: 'category',
    requestSchema: 'category_request_dto.openapi_schema.json',
    responseSchema: 'category_response_dto.openapi_schema.json',
  )
  Future<Response> executeCreate(CategoryRequestDto dto) async {
    return create(dto);
  }

  @override
  @OpenApi(
    path: '/category/',
    method: 'GET',
    summary: 'Find all categorys',
    tag: 'category',
    responseSchema: 'category_response_dto.openapi_schema.json',
    isList: true,
  )
  Future<Response> executeFindAll() {
    return findAll();
  }

  @override
  @OpenApi(
    path: '/category/',
    method: 'PUT',
    summary: 'update category ',
    tag: 'category',
    responseSchema: 'category_response_dto.openapi_schema.json',
  )
  Future<Response> executeUpdate(CategoryRequestDto dto) async {
    return update(dto);
  }

  @override
  @OpenApi(
    path: '/category/{id}',
    method: 'GET',
    summary: 'Find category by id',
    tag: 'category',
    responseSchema: 'category_response_dto.openapi_schema.json',
    isPath: true,
  )
  Future<Response> executeFindById({required String id}) {
    return findById(id);
  }

  @override
  @OpenApi(
    path: '/category/{id}',
    method: 'DELETE',
    summary: 'Delete category by id',
    tag: 'category',
    isPath: true,
  )
  Future<Response> executeDeleteById({required String id}) async {
    return delete(id);
  }
}
