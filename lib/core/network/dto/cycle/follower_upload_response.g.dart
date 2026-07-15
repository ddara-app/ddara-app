// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FollowerUploadResponse _$FollowerUploadResponseFromJson(
  Map<String, dynamic> json,
) => _FollowerUploadResponse(
  shotId: (json['shotId'] as num).toInt(),
  cycleId: (json['cycleId'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  type: json['type'] as String,
  imageUrl: json['imageUrl'] as String,
  uploadedAt: DateTime.parse(json['uploadedAt'] as String),
);

Map<String, dynamic> _$FollowerUploadResponseToJson(
  _FollowerUploadResponse instance,
) => <String, dynamic>{
  'shotId': instance.shotId,
  'cycleId': instance.cycleId,
  'userId': instance.userId,
  'type': instance.type,
  'imageUrl': instance.imageUrl,
  'uploadedAt': instance.uploadedAt.toIso8601String(),
};
