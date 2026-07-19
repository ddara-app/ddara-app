/// 댓글 등록(`POST /api/shots/{shotId}/comments`) 실패 시 서버가 내려주는 에러 코드.
enum CommentErrorCode {
  invalidInput('INVALID_INPUT', '댓글 내용을 확인해 주세요.'),
  notGroupMember('NOT_GROUP_MEMBER', '해당 모임의 멤버가 아니에요.'),
  shotLocked('SHOT_LOCKED', '내 인증샷을 올려야 댓글을 달 수 있어요.'),
  shotNotFound('SHOT_NOT_FOUND', '이미 삭제된 사진이에요.'),
  shotUnderReview('SHOT_UNDER_REVIEW', '검토 중인 사진에는 댓글을 달 수 없어요.'),
  commentForbidden('COMMENT_FORBIDDEN', '내가 작성한 댓글만 삭제할 수 있어요.'),
  commentNotFound('COMMENT_NOT_FOUND', '이미 삭제된 댓글이에요.'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN', '네트워크 연결이 불안정합니다.');

  const CommentErrorCode(this.value, this.message);

  final String value;

  /// 사용자에게 노출할 안내 메시지.
  final String message;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static CommentErrorCode? fromValue(String? value) {
    for (final code in CommentErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}
