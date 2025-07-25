abstract class BaseService<T> {
  Future<List<T>> getAll();

  Future<T?> getById(String id);

  Future<void> create(T entity);

  Future<void> update(String id, T entity);

  Future<void> delete(String id);
}
