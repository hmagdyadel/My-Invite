// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuccessResponse _$SuccessResponseFromJson(Map<String, dynamic> json) =>
    SuccessResponse(
      code: (json['code'] as num?)?.toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SuccessResponseToJson(SuccessResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'description': instance.description,
    };
