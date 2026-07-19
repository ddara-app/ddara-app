import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

/// 사진에 등록된 댓글 하나. (댓글 등록·목록 조회 응답의 도메인 모델)
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
    // 댓글 내용. 신고 접수로 검토 중(underReview)이면 null.
    required String? content,
    // 신고 접수로 검토 중인 댓글인지 여부.
    @Default(false) bool underReview,
    required DateTime createdAt,
    // 수정 시각. 수정된 적 없으면 null.
    DateTime? updatedAt,
  }) = _Comment;
}
