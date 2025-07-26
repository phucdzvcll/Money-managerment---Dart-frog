import 'package:dart_frog/dart_frog.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_dto.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

sealed class ApiResponse {
  const ApiResponse({required this.code, required this.success});

  final int code;
  final bool success;
}

class SuccessResponse extends ApiResponse {
  const SuccessResponse({required this.data}) : super(code: 200, success: true);

  final BaseResponseDto data;

  Map<String, dynamic> toJson() => {
        'code': code,
        'success': success,
        'data': data.toJson(),
      };
}

class SuccessListResponse extends ApiResponse {
  const SuccessListResponse({required this.data})
      : super(code: 200, success: true);

  final List<BaseDto> data;

  Map<String, dynamic> toJson() => {
        'code': code,
        'success': success,
        'data': (data.map((e) => e.toJson())).toList(),
      };
}

class ErrorResponse extends ApiResponse {
  const ErrorResponse({required this.error, this.code = 500})
      : super(code: code, success: false);

  final ApiError error;
  final int code;

  Map<String, dynamic> toJson() => {
        'code': code,
        'success': success,
        'error': error.toJson(),
      };
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

typedef ToJson<T> = Map<String, dynamic> Function(T e);

extension ApiResponseSuccessExtension on ApiResponse {
  Response toResponse({
    Map<String, Object> headers = const <String, Object>{},
  }) {
    final body = switch (this) {
      SuccessResponse() => (this as SuccessResponse).toJson(),
      ErrorResponse() => (this as ErrorResponse).toJson(),
      SuccessListResponse() => (this as SuccessListResponse).toJson(),
    };
    return Response.json(
      statusCode: code,
      headers: headers,
      body: body,
    );
  }
}

final emptyResponse = Response.json(
  statusCode: 200,
  body: const <String, dynamic>{},
  headers: const <String, Object>{},
);
