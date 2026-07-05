import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/model/notification/notification_category.dart';
import 'package:ddara/core/model/notification/notification_list.dart';
import 'package:ddara/data/datasource/notification/notification_datasource.dart';
import 'package:ddara/data/repository/mapper/notification_mapper.dart';
import 'package:ddara/domain/repository/notification_repository.dart';
import 'package:dio/dio.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._notificationDataSource);

  final NotificationDataSource _notificationDataSource;

  @override
  Future<NotificationList> getNotifications({
    required NotificationCategory category,
    required int size,
  }) async {
    try {
      final response = await _notificationDataSource.getNotifications(
        category: category.value,
        size: size,
      );
      return response.toDomain();
    } on DioException {
      // 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      throw NetworkException();
    }
  }
}
