sealed class CommentException implements Exception {}

/// 400 — content 누락, 공백만 입력, 200자 초과.
class InvalidCommentInputException extends CommentException {}

/// 403 — 잠금 상태의 사진. (해당 회차에 인증샷 미업로드)
class ShotLockedException extends CommentException {}

/// 409 — 검토중(신고된) 사진.
class ShotUnderReviewException extends CommentException {}

/// 403 — 본인이 작성한 댓글이 아님. (삭제 권한 없음)
class CommentForbiddenException extends CommentException {}

/// 404 — 댓글 없음.
class CommentNotFoundException extends CommentException {}
