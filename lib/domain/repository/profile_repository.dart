import 'package:ddara/core/model/profile/notification_settings.dart';
import 'package:ddara/core/model/profile/profile.dart';

abstract interface class ProfileRepository {
  Future<Profile> getProfile();

  /// 회원 탈퇴. 애플 계정(iOS)은 연동 해제(revoke)용 [appleAuthorizationCode]
  /// 를 함께 보낸다. (그 외 소셜은 null)
  Future<void> deleteAccount({String? appleAuthorizationCode});

  /// 프로필 이미지를 업로드하고 새 이미지 URL을 반환한다.
  ///
  /// [imagePath] 는 업로드할 로컬 이미지 파일 경로(jpg/png).
  Future<String> uploadProfileImage(String imagePath);

  /// 프로필 이미지를 기본 이미지로 되돌린다.
  Future<void> resetProfileImage();

  Future<NotificationSettings> getNotificationSettings();

  Future<NotificationSettings> changeNotificationSettings(NotificationSettings settings);
}
