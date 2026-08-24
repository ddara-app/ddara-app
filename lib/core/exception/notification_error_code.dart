/// 알림 읽음 처리(`PATCH /api/notifications/{id}/read`) 실패 시 서버가 내려주는 코드.
enum NotificationErrorCode {
  /// 403 — 내 알림이 아님.
  forbidden('NOTIFICATION_FORBIDDEN', '내 알림이 아니에요.'),

  /// 404 — 알림이 없음. (이미 삭제된 경우 포함)
  notFound('NOTIFICATION_NOT_FOUND', '알림을 찾을 수 없어요.'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN', '네트워크 연결이 불안정합니다.');

  const NotificationErrorCode(this.value, this.message);

  final String value;

  /// 사용자에게 노출할 안내 메시지.
  final String message;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static NotificationErrorCode? fromValue(String? value) {
    for (final code in NotificationErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}
