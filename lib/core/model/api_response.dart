import 'package:dart_frog/dart_frog.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/constants/exception_code.dart';
import 'package:mm/core/model/base_dto.dart';

part 'api_response.freezed.dart';

part 'api_response.g.dart';

sealed class ApiResponse {
  const ApiResponse({required this.success});

  final bool success;
}

class SuccessResponse extends ApiResponse {
  const SuccessResponse({required this.data, this.code = 200})
      : super(success: true);

  final BaseResponseDto data;
  final int code;

  Map<String, dynamic> toJson() => {
        'code': code,
        'success': success,
        'data': data.toJson(),
      };
}

final successRsponse = Response.json(
  body: {
    'code': 200,
    'success': true,
    'data': {
      'success': true,
    },
  },
);

class SuccessListResponse extends ApiResponse {
  const SuccessListResponse({required this.data, this.code = 200})
      : super(success: true);

  final List<BaseResponseDto> data;
  final int code;

  Map<String, dynamic> toJson() => {
        'code': code,
        'success': success,
        'data': (data.map((e) => e.toJson())).toList(),
      };
}

class ErrorResponse extends ApiResponse {
  const ErrorResponse({
    required this.error,
  }) : super(success: false);

  final ApiError error;

  Map<String, dynamic> toJson() => {
        'code': error.statusCode,
        'success': success,
        'error': error.toJson(),
      };
}

extension ApiErrorEx on ApiError {
  ErrorResponse get toErrorResponse => ErrorResponse(error: this);

  Response get toResponse => toErrorResponse.toResponse();
}

@freezed
abstract class ApiError with _$ApiError implements Exception {
  const factory ApiError({
    required ErrorCode code,
    required int statusCode,
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
    final code = switch (this) {
      SuccessResponse() => (this as SuccessResponse).code,
      SuccessListResponse() => (this as SuccessListResponse).code,
      ErrorResponse() => (this as ErrorResponse).error.statusCode,
    };
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

final emptyResponse = Response.json();

Response unknowError(String message) =>
    ApiError(code: ErrorCode.UNKNOWN_ERROR, statusCode: 500).toResponse;

Response badRequest(String message, {int code = 400}) =>
    ApiError(code: ErrorCode.BAD_REQUEST, statusCode: code).toResponse;
