import 'package:ddara/domain/model/notification/notification_category.dart';
import 'package:ddara/domain/model/notification/notification_list.dart';

abstract interface class NotificationRepository {
  /// 알림을 전량 받는다. (서버 개수 제한 없음)
  Future<NotificationList> getNotifications({
    required NotificationCategory category,
  });

  /// 안 읽은 알림이 하나라도 있는지.
  Future<bool> hasUnread();

  /// [notificationId] 알림을 읽음으로 표시한다.
  Future<void> markAsRead(int notificationId);
}
