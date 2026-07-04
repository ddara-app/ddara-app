import 'package:ddara/core/model/notification/notification_category.dart';
import 'package:ddara/core/model/notification/notification_item.dart';

class NotificationState {
  /// 조회된 알림 목록.
  final List<NotificationItem> items;

  /// 읽지 않은 알림 개수.
  final int unreadCount;

  /// 현재 필터 카테고리.
  final NotificationCategory category;

  /// 알림 조회 중 여부.
  final bool isLoading;

  /// 조회 실패 메시지. 비어 있으면 에러 없음.
  final String errorMessage;

  const NotificationState({
    this.items = const [],
    this.unreadCount = 0,
    this.category = NotificationCategory.all,
    this.isLoading = false,
    this.errorMessage = '',
  });

  /// 표시할 알림이 하나도 없는지 여부.
  bool get isEmpty => items.isEmpty;

  NotificationState copyWith({
    List<NotificationItem>? items,
    int? unreadCount,
    NotificationCategory? category,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationState(
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      category: category ?? this.category,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
