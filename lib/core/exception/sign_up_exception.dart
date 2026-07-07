sealed class SignException implements Exception {}

/// 400 INVALID_INPUT — 입력값 오류 (필수값 누락, 약관 미동의 등)
class TypeMisMatchException extends SignException {}

/// 401 INVALID_OAUTH_TOKEN — 소셜 토큰 만료/무효
class UnauthorizedTokenException extends SignException {}

/// 500 UNSUPPORTED_OAUTH_PROVIDER — 지원하지 않는 소셜 제공자
class UnsupportedProviderException extends SignException {}
