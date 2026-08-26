import 'package:ddara/domain/repository/notification_repository.dart';

class GetUnreadNotificationUseCase {
  GetUnreadNotificationUseCase(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  Future<bool> call() async {
    return await _notificationRepository.hasUnread();
  }
}
