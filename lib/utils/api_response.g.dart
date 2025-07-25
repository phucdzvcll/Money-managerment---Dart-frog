// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiSuccess<T> _$ApiSuccessFromJson<T extends ApiResponseBase>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiSuccess<T>(
      success: json['success'] as bool,
      code: (json['code'] as num?)?.toInt() ?? 200,
      data: fromJsonT(json['data']),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ApiSuccessToJson<T extends ApiResponseBase>(
  ApiSuccess<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'data': toJsonT(instance.data),
      'runtimeType': instance.$type,
    };

ApiErrorResponse<T> _$ApiErrorResponseFromJson<T extends ApiResponseBase>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiErrorResponse<T>(
      success: json['success'] as bool,
      code: (json['code'] as num?)?.toInt() ?? 500,
      error: ApiError.fromJson(json['error'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ApiErrorResponseToJson<T extends ApiResponseBase>(
  ApiErrorResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'error': instance.error,
      'runtimeType': instance.$type,
    };

_ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => _ApiError(
      code: json['code'] as String,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ApiErrorToJson(_ApiError instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
