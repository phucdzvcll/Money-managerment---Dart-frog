import 'package:dart_either/dart_either.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';

typedef ExecuteFunction<T> = Future<T> Function();

mixin ServiceMixin {
  Future<Either<ApiError, OutPut>> call<OutPut>({
    required ExecuteFunction<OutPut> fn,
  }) async {
    try {
      final result = await fn.call();

      return Either.right(result);
    } on ApiError catch (e) {
      return Either.left(e);
    } catch (e) {
      return Either.left(ApiError(code: UNKNOWN_ERROR));
    }
  }

  Future<OutPut> rawCall<OutPut>({
    required ExecuteFunction<OutPut> fn,
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
