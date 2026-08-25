// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) =>
    _FeedResponse(
      updateCount: (json['updateCount'] as num?)?.toInt() ?? 0,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => FeedItemResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FeedItemResponse>[],
    );

Map<String, dynamic> _$FeedResponseToJson(_FeedResponse instance) =>
    <String, dynamic>{
      'updateCount': instance.updateCount,
      'items': instance.items,
    };

_FeedItemResponse _$FeedItemResponseFromJson(Map<String, dynamic> json) =>
    _FeedItemResponse(
      shotId: (json['shotId'] as num).toInt(),
      type: json['type'] as String,
      imageUrl: json['imageUrl'] as String?,
      imageUnderReview: json['imageUnderReview'] as bool? ?? false,
      userId: (json['userId'] as num).toInt(),
      nickname: json['nickname'] as String,
      groupId: (json['groupId'] as num).toInt(),
      groupName: json['groupName'] as String,
      cycleId: (json['cycleId'] as num).toInt(),
      topic: json['topic'] as String,
      locked: json['locked'] as bool? ?? false,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );

Map<String, dynamic> _$FeedItemResponseToJson(_FeedItemResponse instance) =>
    <String, dynamic>{
      'shotId': instance.shotId,
      'type': instance.type,
      'imageUrl': instance.imageUrl,
      'imageUnderReview': instance.imageUnderReview,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'cycleId': instance.cycleId,
      'topic': instance.topic,
      'locked': instance.locked,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
    };
