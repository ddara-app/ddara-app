import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';

/// 댓글 API(`/api/shots/{shotId}/comments` · `/api/comments/{id}`) 실패.
///
/// 서버 code 문자열 → 예외 매핑을 [fromCode] 한곳에 둔다. 엔드포인트마다
/// 받을 수 있는 코드는 다르지만 코드 하나가 뜻하는 실패는 같으므로,
/// 매핑을 메서드별로 나누지 않고 전체를 한 표로 둔다.
sealed class CommentException implements Exception {
  /// 서버 응답의 code 문자열을 예외로 옮긴다. 매칭 실패 시 null —
  /// 호출부가 `?? NetworkException()` 으로 받는다.
  ///
  /// 댓글 API 는 자기 도메인 밖 실패(모임 미가입·사진 없음)도 함께 내려주므로
  /// 반환 타입이 [CommentException] 이 아니라 [Exception] 이다.
  ///
  /// 401(미인증)은 인터셉터가 따로 처리하므로 여기서 다루지 않는다.
  static Exception? fromCode(String? code) => switch (code) {
    'INVALID_INPUT' => InvalidCommentInputException(),
    'NOT_GROUP_MEMBER' => NotGroupMemberException(),
    'SHOT_LOCKED' => ShotLockedException(),
    'SHOT_NOT_FOUND' => ShotNotFoundException(),
    'SHOT_UNDER_REVIEW' => ShotUnderReviewException(),
    'COMMENT_FORBIDDEN' => CommentForbiddenException(),
    'COMMENT_NOT_FOUND' => CommentNotFoundException(),
    _ => null,
  };
}

/// 400 — content 누락, 공백만 입력, 200자 초과.
class InvalidCommentInputException extends CommentException {}

/// 403 — 잠금 상태의 사진. (해당 회차에 인증샷 미업로드)
class ShotLockedException extends CommentException {}

/// 409 — 검토중(신고된) 사진.
class ShotUnderReviewException extends CommentException {}

/// 403 — 본인이 작성한 댓글이 아님. (수정·삭제 권한 없음)
class CommentForbiddenException extends CommentException {}

/// 404 — 댓글 없음.
class CommentNotFoundException extends CommentException {}
