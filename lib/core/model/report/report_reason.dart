/// 신고 사유. (`POST /api/reports` 의 reasonCode 와 1:1 매핑)
enum ReportReason {
  /// 음란물.
  obscene('OBSCENE'),

  /// 폭력·혐오.
  violence('VIOLENCE'),

  /// 타인 무단촬영.
  unauthorizedPhoto('UNAUTHORIZED_PHOTO'),

  /// 사칭·괴롭힘.
  harassment('HARASSMENT'),

  /// 기타. (신고 시 상세 내용(reasonText)이 필수)
  etc('ETC');

  const ReportReason(this.code);

  /// 서버로 보내는 reasonCode 문자열.
  final String code;
}
