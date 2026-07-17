/// 사용자 차단(`POST /api/blocks`) 실패 시 서버가 내려주는 에러 코드.
enum BlockErrorCode {
  invalidInput('INVALID_INPUT', '자기 자신은 차단할 수 없어요.'),
  userNotFound('USER_NOT_FOUND', '존재하지 않는 사용자예요.'),

  /// 네트워크 오류 등 매칭되는 서버 코드가 없을 때의 기본값.
  unknown('UNKNOWN', '네트워크 연결이 불안정합니다.');

  const BlockErrorCode(this.value, this.message);

  final String value;

  /// 사용자에게 노출할 안내 메시지.
  final String message;

  /// 서버 응답의 code 문자열을 enum 으로 역매핑. 매칭 실패 시 null.
  static BlockErrorCode? fromValue(String? value) {
    for (final code in BlockErrorCode.values) {
      if (code.value == value) return code;
    }
    return null;
  }
}
