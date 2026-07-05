import 'package:dio/dio.dart';

/// FCM 디바이스 토큰을 ddara 백엔드에 등록하는 원격 데이터소스.
///
/// 인증(Bearer)·Content-Type(application/json)은 dio 가 자동으로 붙인다.
class FcmDataSource {
  FcmDataSource(this._dio);

  final Dio _dio;

  static const String _endpoint = '/api/users/me/fcm-token';

  /// 현재 디바이스의 FCM 토큰을 서버에 등록(upsert)한다.
  ///
  /// 예외: 400 INVALID_INPUT(토큰 비어있음), 404 USER_NOT_FOUND.
  Future<void> registerToken(String fcmToken) async {
    await _dio.put(_endpoint, data: {'fcmToken': fcmToken});
  }
}
