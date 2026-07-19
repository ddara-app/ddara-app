// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentResponse _$CommentResponseFromJson(Map<String, dynamic> json) =>
    _CommentResponse(
      commentId: (json['commentId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentResponseToJson(_CommentResponse instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };
