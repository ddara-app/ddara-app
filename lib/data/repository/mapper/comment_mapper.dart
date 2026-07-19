import 'package:ddara/core/model/comment/comment.dart';
import 'package:ddara/core/network/dto/comment/comment_response.dart';

extension CommentMapper on CommentResponse {
  Comment toDomain() {
    return Comment(
      commentId: commentId,
      userId: userId,
      nickname: nickname,
      profileImageUrl: profileImageUrl,
      content: content,
      createdAt: createdAt,
    );
  }
}
