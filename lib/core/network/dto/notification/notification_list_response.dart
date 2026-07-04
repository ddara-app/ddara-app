import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_list_response.freezed.dart';
part 'notification_list_response.g.dart';

@freezed
abstract class NotificationListResponse with _$NotificationListResponse {
  const factory NotificationListResponse({
    required List<NotificationItemResponse> items,
    // 읽지 않은 알림 개수.
    required int unreadCount,
  }) = _NotificationListResponse;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);
}

@freezed
abstract class NotificationItemResponse with _$NotificationItemResponse {
  const factory NotificationItemResponse({
    required int id,
    // 알림 종류. (예: 'MEMBER_JOIN', 'NEW_CYCLE')
    required String type,
    // 알림 종류별로 스키마가 다른 부가 정보.
    required Map<String, dynamic> payload,
    // 아직 읽지 않은 경우 null.
    required DateTime? readAt,
    required DateTime createdAt,
  }) = _NotificationItemResponse;

  factory NotificationItemResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemResponseFromJson(json);
}
