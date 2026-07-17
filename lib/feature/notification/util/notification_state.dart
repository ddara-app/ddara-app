import 'package:ddara/core/model/notification/notification_category.dart';
import 'package:ddara/core/model/notification/notification_item.dart';

class NotificationState {
  /// 조회된 알림 목록.
  final List<NotificationItem> items;

  /// 현재 필터 카테고리.
  final NotificationCategory category;

  /// 내가 차단한 사용자 userId 집합. (차단한 멤버의 썸네일을 가리는 데 사용)
  final Set<int> blockedUserIds;

  /// 알림 조회 중 여부.
  final bool isLoading;

  /// 조회 실패 메시지. 비어 있으면 에러 없음.
  final String errorMessage;

  const NotificationState({
    this.items = const [],
    this.category = NotificationCategory.all,
    this.blockedUserIds = const {},
    this.isLoading = false,
    this.errorMessage = '',
  });

  /// 표시할 알림이 하나도 없는지 여부.
  bool get isEmpty => items.isEmpty;

  NotificationState copyWith({
    List<NotificationItem>? items,
    NotificationCategory? category,
    Set<int>? blockedUserIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationState(
      items: items ?? this.items,
      category: category ?? this.category,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
