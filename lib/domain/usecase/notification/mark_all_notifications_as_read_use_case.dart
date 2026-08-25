import 'package:ddara/domain/repository/notification_repository.dart';

/// 안 읽은 알림을 모두 읽음으로 표시한다.
///
/// 알림 목록 상단의 '전체 읽음'에서 호출한다.
class MarkAllNotificationsAsReadUseCase {
  MarkAllNotificationsAsReadUseCase(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  Future<void> call() async {
    await _notificationRepository.markAllAsRead();
  }
}
