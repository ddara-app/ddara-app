/// 사용자 차단(`POST /api/blocks`) 실패.
///
/// 서버 code 문자열 → 예외 매핑을 [fromCode] 한곳에 둔다. 실패 하나가
/// 코드 enum·예외 클래스·리포지토리 switch 세 곳에 흩어지지 않도록.
sealed class BlockException implements Exception {
  /// 서버 응답의 code 문자열을 예외로 옮긴다. 매칭 실패 시 null —
  /// 호출부가 `?? NetworkException()` 으로 받는다.
  ///
  /// 401(UNAUTHORIZED)은 인터셉터가 따로 처리하므로 여기서 다루지 않는다.
  static Exception? fromCode(String? code) => switch (code) {
    'INVALID_INPUT' => InvalidBlockInputException(),
    'USER_NOT_FOUND' => BlockTargetNotFoundException(),
    _ => null,
  };
}

/// 400 — userId 누락 또는 자기 자신 차단.
class InvalidBlockInputException extends BlockException {}

/// 404 — 차단 대상 유저 없음.
class BlockTargetNotFoundException extends BlockException {}
