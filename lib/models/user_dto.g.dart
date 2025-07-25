// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      token: json['token'] as String?,
      rToken: json['rToken'] as String?,
    );

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
      'username': instance.username,
      'full_name': instance.fullName,
      'token': instance.token,
      'rToken': instance.rToken,
    };
