import 'package:ddara/core/model/profile/notification_settings.dart';
import 'package:ddara/core/model/profile/profile.dart';

abstract interface class ProfileRepository {
  Future<Profile> getProfile();

  Future<void> deleteAccount();

  /// 프로필 이미지를 업로드하고 새 이미지 URL을 반환한다.
  ///
  /// [imagePath] 는 업로드할 로컬 이미지 파일 경로(jpg/png).
  Future<String> uploadProfileImage(String imagePath);

  Future<NotificationSettings> getNotificationSettings();

  Future<NotificationSettings> changeNotificationSettings(NotificationSettings settings);
}
