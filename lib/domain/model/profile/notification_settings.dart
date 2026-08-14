import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.freezed.dart';

@freezed
abstract class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    // 전체 알림 허용 여부.
    required bool allowAll,
    // 따라찍기 알림. (NEW_CYCLE · CYCLE_COMPLETED · DEADLINE)
    required bool followShot,
    // 다른 친구의 따라찍기 알림.
    required bool friendShot,
    // 랜덤 스타터 알림. (STARTER_ASSIGNED)
    required bool starterAssigned,
    // 댓글 알림.
    required bool comment,
    // 멤버 참여 알림. (MEMBER_JOIN)
    required bool memberJoin,
  }) = _NotificationSettings;
}
