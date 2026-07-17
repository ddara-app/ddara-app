sealed class ReportException implements Exception {}

/// 400 — 필수값 누락, 본인 사진 신고, ETC 인데 reasonText 없음.
class InvalidReportInputException extends ReportException {}

/// 404 — 사진 없음. (운영 삭제된 사진 포함)
class ShotNotFoundException extends ReportException {}
