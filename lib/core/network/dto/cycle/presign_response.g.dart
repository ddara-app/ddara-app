// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presign_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PresignResponse _$PresignResponseFromJson(Map<String, dynamic> json) =>
    _PresignResponse(
      uploadUrl: json['uploadUrl'] as String,
      imageUrl: json['imageUrl'] as String,
      expiresIn: (json['expiresIn'] as num).toInt(),
    );

Map<String, dynamic> _$PresignResponseToJson(_PresignResponse instance) =>
    <String, dynamic>{
      'uploadUrl': instance.uploadUrl,
      'imageUrl': instance.imageUrl,
      'expiresIn': instance.expiresIn,
    };
