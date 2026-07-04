import 'package:ddara/core/model/notification/notification_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_list.freezed.dart';

@freezed
abstract class NotificationList with _$NotificationList {
  const factory NotificationList({
    required List<NotificationItem> items,
    // 읽지 않은 알림 개수.
    required int unreadCount,
  }) = _NotificationList;
}
