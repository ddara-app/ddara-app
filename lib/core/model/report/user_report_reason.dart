/// 유저 신고 사유.
/// (`POST /api/reports` 의 targetType=USER 에서 허용되는 reasonCode 와 1:1 매핑)
enum UserReportReason {
  /// 부적절한 닉네임. (욕설·음란·혐오)
  nickname('INAPPROPRIATE_NICKNAME'),

  /// 부적절한 프로필 사진. (음란·혐오)
  profileImage('INAPPROPRIATE_IMAGE'),

  /// 사칭·괴롭힘.
  harassment('HARASSMENT'),

  /// 기타. (신고 시 상세 내용(reasonText)이 필수)
  etc('ETC');

  const UserReportReason(this.code);

  /// 서버로 보내는 reasonCode 문자열.
  final String code;
}