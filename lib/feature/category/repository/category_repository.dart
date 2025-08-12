import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/feature/category/entities/category_entity.dart';
import 'package:postgres/postgres.dart';

abstract class CategoryRepository extends BaseRepository<CategoryEntity> {
  const CategoryRepository(Connection connection)
      : super(connection, 'categories');
}

class CategoryRepositoryImpl extends CategoryRepository {
  const CategoryRepositoryImpl(Connection connection)
      : super(connection);

  @override
  CategoryEntity fromJson(Map<String, dynamic> json) {
    return CategoryEntity.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(CategoryEntity entity) {
    return entity.toJson();
  }
}
