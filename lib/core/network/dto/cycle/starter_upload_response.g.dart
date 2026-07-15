// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starter_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StarterUploadResponse _$StarterUploadResponseFromJson(
  Map<String, dynamic> json,
) => _StarterUploadResponse(
  cycleId: (json['cycleId'] as num).toInt(),
  groupId: (json['groupId'] as num).toInt(),
  cycleNumber: (json['cycleNumber'] as num).toInt(),
  topic: json['topic'] as String,
  starterUserId: (json['starterUserId'] as num).toInt(),
  status: json['status'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  deadlineAt: DateTime.parse(json['deadlineAt'] as String),
  starterShot: StarterShotResponse.fromJson(
    json['starterShot'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$StarterUploadResponseToJson(
  _StarterUploadResponse instance,
) => <String, dynamic>{
  'cycleId': instance.cycleId,
  'groupId': instance.groupId,
  'cycleNumber': instance.cycleNumber,
  'topic': instance.topic,
  'starterUserId': instance.starterUserId,
  'status': instance.status,
  'startedAt': instance.startedAt.toIso8601String(),
  'deadlineAt': instance.deadlineAt.toIso8601String(),
  'starterShot': instance.starterShot,
};

_StarterShotResponse _$StarterShotResponseFromJson(Map<String, dynamic> json) =>
    _StarterShotResponse(
      shotId: (json['shotId'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$StarterShotResponseToJson(
  _StarterShotResponse instance,
) => <String, dynamic>{
  'shotId': instance.shotId,
  'imageUrl': instance.imageUrl,
  'type': instance.type,
};
