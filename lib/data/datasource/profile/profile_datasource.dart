import 'package:ddara/core/network/dto/profile/camera_guide_response.dart';
import 'package:ddara/core/network/dto/profile/notification_settings_request.dart';
import 'package:ddara/core/network/dto/profile/notification_settings_response.dart';
import 'package:ddara/core/network/dto/profile/profile_image_response.dart';
import 'package:ddara/core/network/dto/profile/profile_response.dart';
import 'package:dio/dio.dart';

class ProfileDataSource {
  ProfileDataSource(this._dio);

  final Dio _dio;

  static final String _baseUrl = '/api/users/me';

  Future<ProfileResponse> getProfile() async {
    final response = await _dio.get(_baseUrl);
    return ProfileResponse.fromJson(response.data);
  }

  /// S3에 업로드된 이미지 URL로 프로필 이미지를 갱신하고 새 이미지 URL을 받는다.
  ///
  /// (파일 업로드는 공용 presign 흐름으로 먼저 처리하고, 여기서는 URL만 전달한다)
  Future<ProfileImageResponse> updateProfileImage(String imageUrl) async {
    final response = await _dio.patch(
      '$_baseUrl/profile-image',
      data: {'imageUrl': imageUrl},
    );
    return ProfileImageResponse.fromJson(response.data);
  }

  /// 프로필 이미지를 기본 이미지로 되돌린다. (`imageUrl: null` 전송이 계약)
  Future<void> resetProfileImage() async {
    await _dio.patch('$_baseUrl/profile-image', data: {'imageUrl': null});
  }

  /// 회원 탈퇴. 애플 계정(iOS)은 서버가 애플 연동 해제(token revoke)를
  /// 수행하도록 재인증으로 받은 authorizationCode 를 body 로 함께 보낸다.
  /// 그 외 소셜은 body 없이 보낸다. (응답 body 없음)
  ///
  /// 오류: 401(미인증), 404 `USER_NOT_FOUND`(이미 탈퇴한 계정 포함).
  Future<void> deleteAccount({String? appleAuthorizationCode}) async {
    await _dio.delete(
      _baseUrl,
      data: appleAuthorizationCode == null
          ? null
          : {'appleAuthorizationCode': appleAuthorizationCode},
    );
  }

  Future<NotificationSettingsResponse> changeNotificationSettings(
    NotificationSettingsRequest request,
  ) async {
    final response = await _dio.patch('$_baseUrl/notification-settings', data: request.toJson());
    return NotificationSettingsResponse.fromJson(response.data);
  }

  Future<NotificationSettingsResponse> getNotificationSettings() async {
    final response = await _dio.get('$_baseUrl/notification-settings');
    return NotificationSettingsResponse.fromJson(response.data);
  }

  /// 촬영 화면 가이드를 어디까지 봤는지 조회한다.
  ///
  /// 오류: 404 `USER_NOT_FOUND`.
  Future<CameraGuideResponse> getCameraGuide() async {
    final response = await _dio.get('$_baseUrl/camera-guide');
    return CameraGuideResponse.fromJson(response.data);
  }

  /// [key] 가이드를 본 것으로 기록한다. (응답 body 없음)
  ///
  /// 오류: 400 `INVALID_INPUT`(key 누락/빈 값) · 404 `USER_NOT_FOUND`.
  Future<void> completeCameraGuide(String key) async {
    await _dio.patch('$_baseUrl/camera-guide', data: {'key': key});
  }
}
