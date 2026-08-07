/// 소셜 로그인 시도의 공통 결과. (google · kakao · apple 서비스가 함께 사용)
///
/// 세 서비스의 호출 방식을 `Future<SocialAuthResult>` 하나로 통일해,
/// ViewModel 이 성공/취소/실패를 단일 switch 로 처리할 수 있게 한다.
sealed class SocialAuthResult {
  const SocialAuthResult();
}

/// 인증 성공 — 백엔드 로그인에 쓸 토큰.
final class SocialAuthSuccess extends SocialAuthResult {
  const SocialAuthSuccess(this.token);

  final String token;
}

/// 사용자가 로그인을 취소함. (오류가 아니므로 별도 안내 없이 원상 복귀)
final class SocialAuthCancelled extends SocialAuthResult {
  const SocialAuthCancelled();
}

/// 인증 실패.
final class SocialAuthFailure extends SocialAuthResult {
  const SocialAuthFailure([this.debugMessage]);

  /// 분석·로깅용 상세 사유. 사용자에게 노출하지 않는다.
  final String? debugMessage;
}
