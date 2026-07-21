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
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      latestComments:
          (json['latestComments'] as List<dynamic>?)
              ?.map(
                (e) => FeedCommentResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <FeedCommentResponse>[],
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
      'commentCount': instance.commentCount,
      'latestComments': instance.latestComments,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
    };

_FeedCommentResponse _$FeedCommentResponseFromJson(Map<String, dynamic> json) =>
    _FeedCommentResponse(
      userId: (json['userId'] as num).toInt(),
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      content: json['content'] as String?,
      underReview: json['underReview'] as bool? ?? false,
    );

Map<String, dynamic> _$FeedCommentResponseToJson(
  _FeedCommentResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'nickname': instance.nickname,
  'profileImageUrl': instance.profileImageUrl,
  'content': instance.content,
  'underReview': instance.underReview,
};
