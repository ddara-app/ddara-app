/// 알림 종류. 서버가 내려주는 type 문자열과 매핑된다.
enum NotificationType {
  // 새 사이클이 시작됨.
  newCycle('NEW_CYCLE'),

  // 사이클이 종료됨.
  cycleCompleted('CYCLE_COMPLETED'),

  // 마감(투표) 알림.
  deadline('DEADLINE'),

  // 그룹에 새 멤버가 참여함.
  memberJoin('MEMBER_JOIN'),

  /// 매칭되는 서버 값이 없을 때의 기본값.
  unknown('UNKNOWN');

  const NotificationType(this.value);

  final String value;

  /// 서버 응답의 type 문자열을 enum 으로 역매핑. 매칭 실패 시 [unknown].
  static NotificationType fromValue(String? value) {
    for (final type in NotificationType.values) {
      if (type.value == value) return type;
    }
    return NotificationType.unknown;
  }
}
