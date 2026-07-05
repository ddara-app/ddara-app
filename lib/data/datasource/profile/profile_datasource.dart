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
