/// FCM 디바이스 토큰을 백엔드와 동기화하는 저장소.
abstract interface class FcmRepository {
  /// 현재 디바이스 토큰을 서버에 등록(upsert)한다.
  Future<void> registerToken(String token);
}
