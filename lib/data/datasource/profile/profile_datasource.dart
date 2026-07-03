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

  /// 프로필 이미지를 멀티파트(`image` 필드)로 업로드하고 새 이미지 URL을 받는다.
  ///
  /// Content-Type(multipart/form-data)은 dio 가 FormData 를 감지해 자동 설정한다.
  Future<ProfileImageResponse> uploadProfileImage(String path) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        path,
        filename: path.split(RegExp(r'[/\\]')).last,
        contentType: _mediaTypeOf(path),
      ),
    });

    final response = await _dio.patch('$_baseUrl/profile-image', data: formData);
    return ProfileImageResponse.fromJson(response.data);
  }

  /// 파일 확장자로 이미지 Content-Type 을 정한다. (서버는 jpg/png 만 허용)
  DioMediaType _mediaTypeOf(String path) {
    final ext = path.toLowerCase().split('.').last;
    return switch (ext) {
      'png' => DioMediaType('image', 'png'),
      _ => DioMediaType('image', 'jpeg'),
    };
  }

  /// 회원 탈퇴. (요청 body·응답 body 없음)
  Future<void> deleteAccount() async {
    await _dio.delete(_baseUrl);
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
}
