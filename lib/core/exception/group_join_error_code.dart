/// 모임 참여(`POST /api/groups/join`) 실패 시 서버가 내려주는 에러 코드.
enum GroupJoinErrorCode {
  invalidInput('INVALID_INPUT', '입력값이 올바르지 않아요'),
  invalidInviteCode('INVALID_INVITE_CODE', '유효하지 않은 초대 코드입니다.'),
  groupNotFound('GROUP_NOT_FOUND', '존재하지 않는 초대 코드입니다.'),
  alreadyJoinedGroup('ALREADY_JOINED_GROUP', '이미 참여 중인 모임이에요'),
  groupFull('GROUP_FULL', '이미 꽉 찬 모임이에요. 만든 친구에게 물어봐 주세요'),
  groupLimitExceeded('GROUP_LIMIT_EXCEEDED', '참여할 수 있는 모임 개수를 초과했어요'),
  duplicateGroupNickname('DUPLICATE_GROUP_NICKNAME', '이미 누가 쓰고 있어요. 다른 이름은 어때요?'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN', '네트워크 연결이 불안정합니다.');

  const GroupJoinErrorCode(this.value, this.message);

  final String value;

  /// 사용자에게 노출할 안내 메시지.
  final String message;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static GroupJoinErrorCode? fromValue(String? value) {
    for (final code in GroupJoinErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}
