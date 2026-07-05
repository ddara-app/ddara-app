import 'package:ddara/core/model/notification/notification_category.dart';
import 'package:ddara/core/model/notification/notification_list.dart';

abstract interface class NotificationRepository {
  Future<NotificationList> getNotifications({
    required NotificationCategory category,
    required int size,
  });

  Future<void> markAsRead(int notificationId);
}
