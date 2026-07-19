/// 댓글 신고 사유. (`POST /api/reports` 의 reasonCode 와 매핑)
///
/// 순서가 곧 시트 노출 순서다. 서버 코드는 6종(ABUSE·SEXUAL·HATE·
/// IMPERSONATION·PRIVACY·ETC)이지만, 시트는 5종만 노출하고 PRIVACY 는 쓰지 않는다.
enum CommentReportReason {
  /// 성적 발언.
  sexual('SEXUAL'),

  /// 폭력·혐오 표현.
  violence('HATE'),

  /// 욕설·비방 표현.
  abuse('ABUSE'),

  /// 사칭·괴롭힘.
  harassment('IMPERSONATION'),

  /// 기타. (신고 시 상세 내용(reasonText)이 필수)
  etc('ETC');

  const CommentReportReason(this.code);

  /// 서버로 보내는 reasonCode 문자열.
  final String code;
}
