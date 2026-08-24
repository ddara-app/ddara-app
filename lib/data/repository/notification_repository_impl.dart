import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/notification_error_code.dart';
import 'package:ddara/core/exception/notification_exception.dart';
import 'package:ddara/domain/model/notification/notification_category.dart';
import 'package:ddara/domain/model/notification/notification_list.dart';
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

  @override
  Future<bool> hasUnread() async {
    try {
      final response = await _notificationDataSource.getUnread();
      return response.hasUnread;
    } on DioException {
      // 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      throw NetworkException();
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    try {
      await _notificationDataSource.markAsRead(notificationId);
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? NotificationErrorCode.fromValue(e.response?.data['code'])
          : null;

      // 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      throw switch (code) {
        NotificationErrorCode.forbidden => NotificationForbiddenException(),
        NotificationErrorCode.notFound => NotificationNotFoundException(),
        _ => NetworkException(),
      };
    }
  }
}
