import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_response.freezed.dart';
part 'comment_response.g.dart';

/// 댓글 DTO. (`POST` 단건 응답과 `GET` 목록의 각 항목에 공용으로 쓴다)
///
/// POST 응답에는 [underReview]·[reportedByMe]·[updatedAt] 키가 없으므로 각각
/// false·false·null 로 기본 처리한다.
@freezed
abstract class CommentResponse with _$CommentResponse {
  const factory CommentResponse({
    required int commentId,
    required int userId,
    required String nickname,
    // 프로필 이미지 URL. 없으면 null.
    required String? profileImageUrl,
    required String? content,
    // 신고 접수로 검토 중인 댓글인지 여부.
    @Default(false) bool underReview,
    // 내가 신고한 댓글인지 여부.
    @Default(false) bool reportedByMe,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _CommentResponse;

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseFromJson(json);
}

/// `GET /api/shots/{shotId}/comments` 응답 DTO. (댓글 목록 래퍼)
@freezed
abstract class CommentListResponse with _$CommentListResponse {
  const factory CommentListResponse({
    required List<CommentResponse> comments,
  }) = _CommentListResponse;

  factory CommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseFromJson(json);
}

/// `PATCH /api/comments/{commentId}` 응답 DTO. (수정된 내용·시각만 내려온다)
@freezed
abstract class CommentUpdateResponse with _$CommentUpdateResponse {
  const factory CommentUpdateResponse({
    required int commentId,
    required String content,
    required DateTime updatedAt,
  }) = _CommentUpdateResponse;

  factory CommentUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentUpdateResponseFromJson(json);
}
