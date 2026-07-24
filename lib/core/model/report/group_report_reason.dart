/// 모임 신고 사유.
/// (`POST /api/reports` 의 targetType=GROUP 에서 허용되는 reasonCode 와 1:1 매핑)
enum GroupReportReason {
  /// 부적절한 모임 이름·이미지. (욕설·음란·혐오)
  inappropriateGroup('INAPPROPRIATE_GROUP'),

  /// 기타. (신고 시 상세 내용(reasonText)이 필수)
  etc('ETC');

  const GroupReportReason(this.code);

  /// 서버로 보내는 reasonCode 문자열.
  final String code;
}
