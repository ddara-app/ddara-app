import 'package:ddara/domain/repository/notification_repository.dart';

class MarkNotificationAsReadUseCase {
  MarkNotificationAsReadUseCase(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  Future<void> call(int notificationId) {
    return _notificationRepository.markAsRead(notificationId);
  }
}
