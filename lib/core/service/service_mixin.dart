import 'package:dart_either/dart_either.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:postgres/postgres.dart';

typedef ExecuteFunction<T> = Future<T> Function();
typedef TransactionFunction<T> = Future<T> Function(TxSession s);
typedef DataMapper<I, O> = O Function(I);

mixin ServiceMixin {
  Future<Either<ApiError, OUTPUT>> call<OUTPUT, INPUT>({
    required ExecuteFunction<INPUT> fn,
    required DataMapper<INPUT, OUTPUT> mapper,
    Connection? connection,
  }) async {
    try {
      final result = await fn.call();
      return Either.right(mapper(result));
    } on ApiError catch (e) {
      return Either.left(e);
    } on ServerException catch (e) {
      return Either.left(
          ApiError(code: ErrorCode.SERVER_ERROR, message: e.message, statusCode: 500));
    } catch (e) {
      return Either.left(ApiError(
          code: ErrorCode.UNKNOWN_ERROR, message: e.toString(), statusCode: 500));
    }
  }

  Future<Either<ApiError, OUTPUT>> callWithTransaction<OUTPUT, INPUT>({
    required TransactionFunction<INPUT> fn,
    required DataMapper<INPUT, OUTPUT> mapper,
    required Connection connection,
  }) async {
    try {
      final result = await connection.runTx(fn);
      return Either.right(mapper(result));
    } on ApiError catch (e) {
      return Either.left(e);
    } on ServerException catch (e) {
      return Either.left(
          ApiError(code: ErrorCode.SERVER_ERROR, message: e.message, statusCode: 500));
    } catch (e) {
      return Either.left(ApiError(
          code: ErrorCode.UNKNOWN_ERROR, message: e.toString(), statusCode: 500));
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
      return Either.left(
          ApiError(code: ErrorCode.SERVER_ERROR, message: e.message, statusCode: 500));
    } catch (e) {
      return const Either.left(ApiError(code: ErrorCode.UNKNOWN_ERROR, statusCode: 500));
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
      throw const ApiError(code: ErrorCode.UNKNOWN_ERROR, statusCode: 500);
    }
  }
}
