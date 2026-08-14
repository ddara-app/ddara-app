import 'package:ddara/domain/model/notification/notification_category.dart';
import 'package:ddara/domain/model/notification/notification_list.dart';
import 'package:ddara/domain/repository/notification_repository.dart';

class GetNotificationsUseCase {
  GetNotificationsUseCase(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  Future<NotificationList> call({
    NotificationCategory category = NotificationCategory.all,
    int size = 20,
  }) async {
    return await _notificationRepository.getNotifications(
      category: category,
      size: size,
    );
  }
}
