/// 신고 접수(`POST /api/reports`) 실패 시 서버가 내려주는 에러 코드.
enum ReportErrorCode {
  invalidInput('INVALID_INPUT', '신고 내용이 올바르지 않아요.'),
  notGroupMember('NOT_GROUP_MEMBER', '해당 모임의 멤버가 아니에요.'),
  shotNotFound('SHOT_NOT_FOUND', '이미 삭제된 사진이에요.'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN', '네트워크 연결이 불안정합니다.');

  const ReportErrorCode(this.value, this.message);

  final String value;

  /// 사용자에게 노출할 안내 메시지.
  final String message;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static ReportErrorCode? fromValue(String? value) {
    for (final code in ReportErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}
