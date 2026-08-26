import 'package:ddara/domain/repository/notification_repository.dart';

/// 알림을 읽음으로 표시한다.
///
/// 알림 목록에서 항목을 눌렀을 때와, 푸시 알림을 눌러 앱이 열렸을 때 호출한다.
class MarkNotificationAsReadUseCase {
  MarkNotificationAsReadUseCase(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  Future<void> call(int notificationId) async {
    await _notificationRepository.markAsRead(notificationId);
  }
}
