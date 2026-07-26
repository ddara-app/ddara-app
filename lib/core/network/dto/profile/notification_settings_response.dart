import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings_response.freezed.dart';
part 'notification_settings_response.g.dart';

@freezed
abstract class NotificationSettingsResponse with _$NotificationSettingsResponse {
  const factory NotificationSettingsResponse({
    // 전체 알림 허용 여부.
    required bool allowAll,
    // 활동 관련 알림 설정.
    required ActivityNotificationResponse activity,
    // 기타 알림 설정.
    required EtcNotificationResponse etc,
  }) = _NotificationSettingsResponse;

  factory NotificationSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsResponseFromJson(json);
}

@freezed
abstract class ActivityNotificationResponse with _$ActivityNotificationResponse {
  const factory ActivityNotificationResponse({
    // 따라찍기 알림. (NEW_CYCLE · CYCLE_COMPLETED · DEADLINE)
    required bool followShot,
    // 다른 친구의 따라찍기 알림.
    required bool friendShot,
    // 랜덤 스타터 알림. (STARTER_ASSIGNED)
    required bool starterAssigned,
    // 댓글 알림.
    required bool comment,
  }) = _ActivityNotificationResponse;

  factory ActivityNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivityNotificationResponseFromJson(json);
}

@freezed
abstract class EtcNotificationResponse with _$EtcNotificationResponse {
  const factory EtcNotificationResponse({
    // 멤버 참여 알림.
    required bool memberJoin,
  }) = _EtcNotificationResponse;

  factory EtcNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$EtcNotificationResponseFromJson(json);
}
