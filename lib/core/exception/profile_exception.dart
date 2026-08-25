/// 내 정보(`/api/users/me`) 관련 실패.
///
/// 서버 code 문자열 → 예외 매핑을 [fromCode] 한곳에 둔다.
sealed class ProfileException implements Exception {
  /// 서버 응답의 code 문자열을 예외로 옮긴다. 매칭 실패 시 null —
  /// 호출부가 `?? NetworkException()` 으로 받는다.
  ///
  /// 401(UNAUTHORIZED)은 인터셉터가 따로 처리하므로 여기서 다루지 않는다.
  static Exception? fromCode(String? code) => switch (code) {
    'USER_NOT_FOUND' => UserNotFoundException(),
    'INVALID_IMAGE_FILE' => InvalidImageFileException(),
    'INVALID_INPUT' => InvalidInputException(),
    _ => null,
  };
}

/// 404 — 사용자를 찾을 수 없음. (이미 탈퇴한 계정 포함)
class UserNotFoundException extends ProfileException {}

/// 400 — 프로필 이미지가 jpg/png 형식이 아님.
class InvalidImageFileException extends ProfileException {}

/// 400 — 요청 값이 비었거나 형식이 잘못됨. (카메라 가이드 key 누락 등)
class InvalidInputException extends ProfileException {}
