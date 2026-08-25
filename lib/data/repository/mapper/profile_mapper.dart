import 'package:ddara/domain/model/profile/notification_settings.dart';
import 'package:ddara/domain/model/profile/profile.dart';
import 'package:ddara/core/network/dto/profile/notification_settings_request.dart';
import 'package:ddara/core/network/dto/profile/notification_settings_response.dart';
import 'package:ddara/core/network/dto/profile/profile_response.dart';

extension ProfileMapper on ProfileResponse {
  Profile toDomain() {
    return Profile(
      id: id,
      name: name,
      profileImageUrl: profileImageUrl,
      provider: provider,
      createdAt: createdAt,
    );
  }
}

extension NotificationSettingsMapper on NotificationSettingsResponse {
  NotificationSettings toDomain() {
    // 중첩 구조(activity·etc)를 평탄한 도메인 모델로 펼친다.
    return NotificationSettings(
      allowAll: allowAll,
      followShot: activity.followShot,
      friendShot: activity.friendShot,
      starterAssigned: activity.starterAssigned,
      memberJoin: etc.memberJoin,
    );
  }
}

extension NotificationSettingsRequestMapper on NotificationSettings {
  NotificationSettingsRequest toRequest() {
    // 평탄한 도메인 모델을 서버가 기대하는 중첩 구조(activity·etc)로 재구성한다.
    return NotificationSettingsRequest(
      allowAll: allowAll,
      activity: ActivityNotificationRequest(
        followShot: followShot,
        friendShot: friendShot,
        starterAssigned: starterAssigned,
      ),
      etc: EtcNotificationRequest(memberJoin: memberJoin),
    );
  }
}
