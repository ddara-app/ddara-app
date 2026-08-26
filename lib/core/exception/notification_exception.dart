/// 알림 읽음 처리(`PATCH /api/notifications/{id}/read`) 실패.
///
/// 서버 code 문자열 → 예외 매핑을 [fromCode] 한곳에 둔다.
sealed class NotificationException implements Exception {
  /// 서버 응답의 code 문자열을 예외로 옮긴다. 매칭 실패 시 null —
  /// 호출부가 `?? NetworkException()` 으로 받는다.
  static Exception? fromCode(String? code) => switch (code) {
    'NOTIFICATION_FORBIDDEN' => NotificationForbiddenException(),
    'NOTIFICATION_NOT_FOUND' => NotificationNotFoundException(),
    _ => null,
  };
}

/// 403 — 내 알림이 아님.
class NotificationForbiddenException extends NotificationException {}

/// 404 — 알림이 없음. (이미 삭제된 경우 포함)
class NotificationNotFoundException extends NotificationException {}
