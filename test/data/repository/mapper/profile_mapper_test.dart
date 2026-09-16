import 'package:ddara/core/network/dto/profile/notification_settings_response.dart';
import 'package:ddara/core/network/dto/profile/profile_response.dart';
import 'package:ddara/data/repository/mapper/profile_mapper.dart';
import 'package:ddara/domain/model/profile/notification_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileMapper', () {
    test('DTO 필드를 그대로 도메인 모델로 옮긴다', () {
      final response = ProfileResponse(
        id: 1,
        name: 'kim',
        profileImageUrl: null,
        provider: 'KAKAO',
        createdAt: DateTime(2026, 1, 1),
      );

      final result = response.toDomain();

      expect(result.id, 1);
      expect(result.name, 'kim');
      expect(result.profileImageUrl, isNull);
      expect(result.provider, 'KAKAO');
    });
  });

  group('NotificationSettingsMapper', () {
    test('중첩된 activity·etc 구조를 평탄한 도메인 모델로 펼친다', () {
      const response = NotificationSettingsResponse(
        allowAll: true,
        activity: ActivityNotificationResponse(
          followShot: true,
          friendShot: false,
          starterAssigned: true,
          comment: false,
        ),
        etc: EtcNotificationResponse(memberJoin: true),
      );

      final result = response.toDomain();

      expect(result.allowAll, true);
      expect(result.followShot, true);
      expect(result.friendShot, false);
      expect(result.starterAssigned, true);
      expect(result.comment, false);
      expect(result.memberJoin, true);
    });
  });

  group('NotificationSettingsRequestMapper', () {
    test('평탄한 도메인 모델을 서버가 기대하는 중첩 구조로 재구성한다', () {
      const settings = NotificationSettings(
        allowAll: false,
        followShot: true,
        friendShot: true,
        starterAssigned: false,
        comment: true,
        memberJoin: false,
      );

      final request = settings.toRequest();

      expect(request.allowAll, false);
      expect(request.activity.followShot, true);
      expect(request.activity.friendShot, true);
      expect(request.activity.starterAssigned, false);
      expect(request.activity.comment, true);
      expect(request.etc.memberJoin, false);
    });
  });
}
