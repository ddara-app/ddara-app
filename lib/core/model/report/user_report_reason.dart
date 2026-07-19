/// 유저 신고 사유.
///
/// TODO: 서버로 보낼 reasonCode 매핑 추가. (유저 신고 API 스펙 대기 — 현재 UI 전용)
enum UserReportReason {
  /// 부적절한 닉네임. (욕설·음란·혐오)
  nickname,

  /// 부적절한 프로필 사진. (음란·혐오)
  profileImage,

  /// 사칭·괴롭힘.
  harassment,

  /// 기타. (신고 시 상세 내용이 필수)
  etc,
}