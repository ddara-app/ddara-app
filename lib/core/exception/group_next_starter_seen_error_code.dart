/// 다음 스타터 공개 확인 처리(`POST /api/groups/{groupId}/next-starter/seen`)
/// 실패 시 서버가 내려주는 에러 코드.
enum GroupNextStarterSeenErrorCode {
  notGroupMember('NOT_GROUP_MEMBER', '해당 모임의 멤버가 아니에요.'),
  groupNotFound('GROUP_NOT_FOUND', '존재하지 않는 모임이에요.'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN', '네트워크 연결이 불안정합니다.');

  const GroupNextStarterSeenErrorCode(this.value, this.message);

  final String value;

  /// 사용자에게 노출할 안내 메시지.
  final String message;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static GroupNextStarterSeenErrorCode? fromValue(String? value) {
    for (final code in GroupNextStarterSeenErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}
