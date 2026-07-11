/// 스타터 사이클 생성(`POST /api/groups/{groupId}/cycles`) 실패 시 서버가 내려주는 에러 코드.
enum StarterUploadErrorCode {
  invalidInput('INVALID_INPUT', '컨셉 또는 이미지가 올바르지 않습니다.'),
  unauthorized('UNAUTHORIZED', '로그인이 필요합니다.'),
  notGroupMember('NOT_GROUP_MEMBER', '모임 멤버가 아닙니다.'),
  groupNotFound('GROUP_NOT_FOUND', '존재하지 않는 모임입니다.'),
  notEnoughMembers('NOT_ENOUGH_MEMBERS', '활동 멤버가 3명 이상이어야 시작할 수 있어요.'),
  cycleAlreadyInProgress('CYCLE_ALREADY_IN_PROGRESS', '이미 진행 중인 회차가 있어요.'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN', '네트워크 연결이 불안정합니다.');

  const StarterUploadErrorCode(this.value, this.message);

  final String value;

  /// 사용자에게 노출할 안내 메시지.
  final String message;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static StarterUploadErrorCode? fromValue(String? value) {
    for (final code in StarterUploadErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}
