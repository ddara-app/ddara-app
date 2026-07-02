import 'package:ddara/core/network/dto/fcm/fcm_token_request.dart';
import 'package:dio/dio.dart';

/// FCM 디바이스 토큰을 ddara 백엔드에 등록/삭제하는 원격 데이터소스.
///
/// 인증(Bearer)은 dio 인터셉터가 자동으로 붙이므로 여기서 다루지 않는다.
class FcmDataSource {
  FcmDataSource(this._dio);

  final Dio _dio;

  // TODO(fcm): 백엔드 FCM 토큰 엔드포인트가 확정되면 아래 경로/HTTP 메서드/요청
  //  body 형식을 실제 스펙으로 교체한다. (현재 백엔드 구현 중이라 잠정 경로)
  //  - REST 관례상 기존 프로필 API(`/api/users/me/...`)와 결을 맞춰 잠정 지정.
  //  - 서버가 upsert(같은 토큰 재전송 무해)를 보장한다는 전제로 설계함.
  static const String _endpoint = '/api/users/me/fcm-token';

  /// 현재 디바이스의 FCM 토큰을 서버에 등록(upsert)한다.
  Future<void> registerToken(FcmTokenRequest request) async {
    await _dio.post(_endpoint, data: request.toJson());
  }

  /// 로그아웃 등으로 이 디바이스에 더 이상 푸시를 보내지 않도록 토큰을 삭제한다.
  Future<void> deleteToken(String token) async {
    await _dio.delete(_endpoint, data: {'token': token});
  }
}
