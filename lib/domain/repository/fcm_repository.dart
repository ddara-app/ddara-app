/// FCM 디바이스 토큰을 백엔드와 동기화하는 저장소.
abstract interface class FcmRepository {
  /// 현재 디바이스 토큰을 서버에 등록(upsert)한다.
  ///
  /// [platform] 은 발급 플랫폼 식별자. (예: "ios" / "android")
  Future<void> registerToken({required String token, required String platform});

  /// 이 디바이스 토큰을 서버에서 삭제한다. (로그아웃 등)
  Future<void> deleteToken(String token);
}
