import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

/// 사진에 등록된 댓글 하나. (`POST /api/shots/{shotId}/comments` 응답의 도메인 모델)
@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required int commentId,
    // 작성자 userId.
    required int userId,
    // 작성자 닉네임. (모임 내 닉네임)
    required String nickname,
    // 작성자 프로필 이미지 URL. 없으면 null.
    required String? profileImageUrl,
    required String content,
    required DateTime createdAt,
  }) = _Comment;
}
