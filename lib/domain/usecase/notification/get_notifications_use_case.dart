import 'package:ddara/core/model/notification/notification_category.dart';
import 'package:ddara/core/model/notification/notification_list.dart';
import 'package:ddara/domain/repository/notification_repository.dart';

class GetNotificationsUseCase {
  GetNotificationsUseCase(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  Future<NotificationList> call({
    NotificationCategory category = NotificationCategory.all,
    int size = 20,
  }) async {
    final test =  await _notificationRepository.getNotifications(
      category: category,
      size: size,
    );

    print('===================== items(${test.items.length}) =====================');
    for (var i = 0; i < test.items.length; i++) {
      print('[$i] ${test.items[i]}');
    }
    print('====================================================');
    return test;
  }
}
