import 'package:ddara/domain/model/notification/notification_category.dart';
import 'package:ddara/domain/model/notification/notification_list.dart';
import 'package:ddara/domain/repository/notification_repository.dart';

class GetNotificationsUseCase {
  GetNotificationsUseCase(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  /// 알림을 전량 받는다. 화면은 받은 목록을 클라이언트 사이드 페이징으로
  /// 나눠 그린다. (docs/tech_notes/client_side_paging.md)
  Future<NotificationList> call({
    NotificationCategory category = NotificationCategory.all,
  }) async {
    return await _notificationRepository.getNotifications(category: category);
  }
}
