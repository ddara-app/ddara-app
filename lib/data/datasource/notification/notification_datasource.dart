import 'package:ddara/core/network/dto/notification/notification_list_response.dart';
import 'package:dio/dio.dart';

class NotificationDataSource {
  NotificationDataSource(this._dio);

  final Dio _dio;

  static final String _baseUrl = '/api/notifications';

  /// 알림 목록을 조회한다.
  /// [category] 는 all·activity·etc 중 하나, [size] 는 조회할 개수.
  Future<NotificationListResponse> getNotifications({
    required String category,
    required int size,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {'category': category, 'size': size},
    );
    return NotificationListResponse.fromJson(response.data);
  }
}
