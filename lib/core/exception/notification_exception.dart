sealed class NotificationException implements Exception {}

/// 403 — 내 알림이 아님.
class NotificationForbiddenException extends NotificationException {}

/// 404 — 알림이 없음. (이미 삭제된 경우 포함)
class NotificationNotFoundException extends NotificationException {}
