import 'package:dart_either/dart_either.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:postgres/postgres.dart';

typedef ExecuteFunction<T> = Future<T> Function();
typedef DataMapper<I, O> = O Function(I);

mixin ServiceMixin {
  Future<Either<ApiError, OUTPUT>> call<OUTPUT, INPUT>({
    required ExecuteFunction<INPUT> fn,
    required DataMapper<INPUT, OUTPUT> mapper,
  }) async {
    try {
      final result = await fn.call();
      return Either.right(mapper(result));
    } on ApiError catch (e) {
      return Either.left(e);
    } on ServerException catch (e) {
      return Either.left(ApiError(code: SERVER_ERROR, message: e.message));
    } catch (e) {
      return Either.left(ApiError(code: UNKNOWN_ERROR));
    }
  }

  Future<Either<ApiError, List<OUTPUT>>> calls<OUTPUT, INPUT>({
    required ExecuteFunction<List<INPUT>> fn,
    required DataMapper<INPUT, OUTPUT> mapper,
  }) async {
    try {
      final result = await fn.call();

      return Either.right(result.map(mapper).toList());
    } on ApiError catch (e) {
      return Either.left(e);
    } on ServerException catch (e) {
      return Either.left(ApiError(code: SERVER_ERROR, message: e.message));
    } catch (e) {
      return Either.left(ApiError(code: UNKNOWN_ERROR));
    }
  }

  Future<OUTPUT> rawCall<OUTPUT>({
    required ExecuteFunction<OUTPUT> fn,
  }) async {
    try {
      final result = await fn.call();
      return result;
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(code: UNKNOWN_ERROR);
    }
  }
}
