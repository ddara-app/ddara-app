/// 팔로워 사진 업로드(`POST /api/cycles/{cycleId}/shots`) 실패 시 서버가 내려주는 에러 코드.
enum FollowerUploadErrorCode {
  notGroupMember('NOT_GROUP_MEMBER', '모임 멤버가 아닙니다.'),
  cycleNotFound('CYCLE_NOT_FOUND', '존재하지 않는 회차입니다.'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN', '네트워크 연결이 불안정합니다.');

  const FollowerUploadErrorCode(this.value, this.message);

  final String value;

  /// 사용자에게 노출할 안내 메시지.
  final String message;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static FollowerUploadErrorCode? fromValue(String? value) {
    for (final code in FollowerUploadErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}
