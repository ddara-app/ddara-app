import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.freezed.dart';

@freezed
abstract class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    // 전체 알림 허용 여부.
    required bool allowAll,
    // 따라찍기 알림.
    required bool followShot,
    // 마감 투표 알림.
    required bool deadlineVote,
    // 멤버 참여 알림.
    required bool memberJoin,
  }) = _NotificationSettings;
}
