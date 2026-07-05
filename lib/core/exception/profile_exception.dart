sealed class ProfileException implements Exception {}

/// 404 — 사용자를 찾을 수 없음.
class UserNotFoundException extends ProfileException {}

/// 400 — 프로필 이미지가 jpg/png 형식이 아님.
class InvalidImageFileException extends ProfileException {}
