/// 모임 닉네임 변경(`PATCH /api/groups/{groupId}/members/me/nickname`) 실패 시 서버가 내려주는 에러 코드.
///
/// 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기에 포함하지 않는다.
///
/// enum 은 서버 코드 값만 갖는다. 사용자 노출 문구는 이 코드를 예외로 옮긴 뒤
/// 화면이 l10n 으로 매핑한다.
enum GroupChangeNickNameErrorCode {
  invalidInput('INVALID_INPUT'),
  notGroupMember('NOT_GROUP_MEMBER'),
  groupNotFound('GROUP_NOT_FOUND'),
  duplicateGroupNickname('DUPLICATE_GROUP_NICKNAME'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN');

  const GroupChangeNickNameErrorCode(this.value);

  final String value;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static GroupChangeNickNameErrorCode? fromValue(String? value) {
    for (final code in GroupChangeNickNameErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}
