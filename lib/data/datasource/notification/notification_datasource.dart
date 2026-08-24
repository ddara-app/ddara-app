import 'package:ddara/core/network/dto/notification/notification_list_response.dart';
import 'package:ddara/core/network/dto/notification/unread_notification_response.dart';
import 'package:dio/dio.dart';

class NotificationDataSource {
  NotificationDataSource(this._dio);

  final Dio _dio;

  static final String _baseUrl = '/api/notifications';

  /// 알림 목록을 조회한다.
  ///
  /// [category] 는 all·activity·etc 중 하나.
  ///
  /// 개수 제한 없이 전량 받는다. 화면에 나눠 그리는 일은 클라이언트 사이드
  /// 페이징이 맡는다. (docs/tech_notes/client_side_paging.md)
  Future<NotificationListResponse> getNotifications({
    required String category,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {'category': category},
    );
    return NotificationListResponse.fromJson(response.data);
  }

  /// 안 읽은 알림이 하나라도 있는지 조회한다.
  ///
  /// 목록을 받지 않고 여부만 확인하는 경량 API 다. (홈 종 아이콘 분기용)
  Future<UnreadNotificationResponse> getUnread() async {
    final response = await _dio.get('$_baseUrl/unread');
    return UnreadNotificationResponse.fromJson(response.data);
  }

  /// [notificationId] 알림을 읽음으로 표시한다. (응답 body 없음)
  ///
  /// 이미 읽은 알림을 다시 보내도 성공으로 돌아온다.
  /// 오류: 403 `NOTIFICATION_FORBIDDEN` · 404 `NOTIFICATION_NOT_FOUND`.
  Future<void> markAsRead(int notificationId) async {
    await _dio.patch('$_baseUrl/$notificationId/read');
  }
}
