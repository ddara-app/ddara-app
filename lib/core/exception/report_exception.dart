sealed class ReportException implements Exception {}

/// 400 — 필수값 누락, 본인 콘텐츠 신고, ETC 인데 reasonText 없음,
/// targetType 에 허용되지 않는 reasonCode, USER 인데 groupId 누락.
class InvalidReportInputException extends ReportException {}

/// 404 — 사진 없음. (운영 삭제된 사진 포함)
class ShotNotFoundException extends ReportException {}

/// 404 — 신고 대상 유저가 해당 모임의 멤버가 아니거나 없음.
class ReportUserNotFoundException extends ReportException {}
