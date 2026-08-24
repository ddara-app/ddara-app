import 'package:ddara/domain/model/notification/notification_category.dart';
import 'package:ddara/domain/model/notification/notification_list.dart';

abstract interface class NotificationRepository {
  Future<NotificationList> getNotifications({
    required NotificationCategory category,
    required int size,
  });

  /// [notificationId] 알림을 읽음으로 표시한다.
  Future<void> markAsRead(int notificationId);
}
