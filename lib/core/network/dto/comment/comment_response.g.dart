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
      content: json['content'] as String?,
      underReview: json['underReview'] as bool? ?? false,
      reportedByMe: json['reportedByMe'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CommentResponseToJson(_CommentResponse instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'content': instance.content,
      'underReview': instance.underReview,
      'reportedByMe': instance.reportedByMe,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_CommentListResponse _$CommentListResponseFromJson(Map<String, dynamic> json) =>
    _CommentListResponse(
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentListResponseToJson(
  _CommentListResponse instance,
) => <String, dynamic>{'comments': instance.comments};

_CommentUpdateResponse _$CommentUpdateResponseFromJson(
  Map<String, dynamic> json,
) => _CommentUpdateResponse(
  commentId: (json['commentId'] as num).toInt(),
  content: json['content'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CommentUpdateResponseToJson(
  _CommentUpdateResponse instance,
) => <String, dynamic>{
  'commentId': instance.commentId,
  'content': instance.content,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
