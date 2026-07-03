import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings_request.freezed.dart';
part 'notification_settings_request.g.dart';

@freezed
abstract class NotificationSettingsRequest with _$NotificationSettingsRequest {
  const factory NotificationSettingsRequest({
    // 전체 알림 허용 여부.
    required bool allowAll,
    // 활동 관련 알림 설정.
    required ActivityNotificationRequest activity,
    // 기타 알림 설정.
    required EtcNotificationRequest etc,
  }) = _NotificationSettingsRequest;

  factory NotificationSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsRequestFromJson(json);
}

@freezed
abstract class ActivityNotificationRequest with _$ActivityNotificationRequest {
  const factory ActivityNotificationRequest({
    // 따라찍기 알림.
    required bool followShot,
    // 마감 투표 알림.
    required bool deadlineVote,
  }) = _ActivityNotificationRequest;

  factory ActivityNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$ActivityNotificationRequestFromJson(json);
}

@freezed
abstract class EtcNotificationRequest with _$EtcNotificationRequest {
  const factory EtcNotificationRequest({
    // 멤버 참여 알림.
    required bool memberJoin,
  }) = _EtcNotificationRequest;

  factory EtcNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$EtcNotificationRequestFromJson(json);
}
