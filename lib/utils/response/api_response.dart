import 'package:dart_frog/dart_frog.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';

part 'api_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T extends ApiResponseBase> with _$ApiResponse<T> {
  const factory ApiResponse.success({
    required bool success,
    @Default(200) int code,
    required T data,
  }) = ApiSuccess<T>;

  const factory ApiResponse.error({
    required bool success,
    @Default(500) int code,
    required ApiError error,
  }) = ApiErrorResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

@freezed
abstract class ApiError with _$ApiError implements Exception {
  const factory ApiError({
    required String code,
    String? message,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}
//
// extension ApiResponseErrorExtension on ApiResponse<dynamic> {
//   Response toErrorResponse({
//     int statusCode = 500,
//     Map<String, Object> headers = const <String, Object>{},
//   }) {
//     return Response.json(
//       statusCode: statusCode,
//       body: toJson((e) => {}),
//       headers: {
//         ...headers,
//         'Content-Type': 'application/json',
//       },
//     );
//   }
// }

typedef ToJson<T> = Map<String, dynamic> Function(T e);

extension ApiResponseSuccessExtension<T extends ApiResponseBase>
    on ApiResponse<T> {
  Response toResponse({
    int statusCode = 200,
    Map<String, Object> headers = const <String, Object>{},
  }) {
    return when(success: (
      bool success,
      code,
      data,
    ) {
      return Response.json(
        statusCode: code,
        body: data.toJson(),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
      );
    }, error: (_, code, ApiError error) {
      return Response.json(
        statusCode: code,
        body: {
          'success': false,
          'code': code,
          'error': error.toJson(),
        },
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
      );
    });
  }
}

abstract class ApiResponseBase {
  const ApiResponseBase();
  Map<String, dynamic> toJson();
}
