sealed class CycleException implements Exception {}

/// 400 — topic 누락·길이 위반 또는 이미지 누락.
class InvalidStarterInputException extends CycleException {}

/// presigned URL 발급 또는 S3 업로드 실패.
class StarterImageUploadException extends CycleException {}

/// 404 — 회차(사이클) 없음.
class CycleNotFoundException extends CycleException {}

/// 409 — 활동 멤버 3명 미만이라 사이클을 시작할 수 없음.
class NotEnoughMembersException extends CycleException {}

/// 409 — 이미 진행 중인 회차가 있어 새로 시작할 수 없음.
class CycleAlreadyInProgressException extends CycleException {}
