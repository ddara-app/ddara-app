import 'package:ddara/core/model/notification/notification_category.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/notification/util/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationNotifier extends AutoDisposeNotifier<NotificationState> {
  @override
  NotificationState build() {
    // 진입 시 전체(all) 알림을 조회한다. (build 는 동기라 fire-and-forget)
    _load(NotificationCategory.all);
    return const NotificationState(isLoading: true);
  }

  /// 현재 필터로 알림 목록을 다시 조회한다. (당겨서 새로고침)
  Future<void> refresh() => _load(state.category);

  /// 알림 한 건을 읽음 처리한다.
  /// UI 를 먼저 읽음으로 바꾼 뒤(낙관적 업데이트) 서버에 반영하고, 실패하면 되돌린다.
  Future<void> markAsRead(int notificationId) async {
    final index = state.items.indexWhere((item) => item.id == notificationId);
    // 목록에 없거나 이미 읽은 알림은 아무 것도 하지 않는다.
    if (index < 0 || state.items[index].isRead) return;

    final previous = state;
    final updatedItems = [...state.items];
    updatedItems[index] = updatedItems[index].copyWith(readAt: DateTime.now());
    state = state.copyWith(
      items: updatedItems,
      unreadCount: (state.unreadCount - 1).clamp(0, state.unreadCount),
    );

    try {
      await ref.read(markNotificationAsReadUseCaseProvider)(notificationId);
    } catch (_) {
      // 서버 반영 실패 시 이전 상태로 되돌린다.
      state = previous;
    }
  }

  /// 필터 카테고리를 바꾸고 목록을 다시 조회한다. (같은 카테고리면 무시)
  Future<void> changeCategory(NotificationCategory category) {
    if (state.category == category) return Future.value();
    state = state.copyWith(
      category: category,
      isLoading: true,
      errorMessage: '',
    );
    return _load(category);
  }

  Future<void> _load(NotificationCategory category) async {
    final getNotifications = ref.read(getNotificationsUseCaseProvider);

    try {
      final result = await getNotifications(category: category);
      state = state.copyWith(
        isLoading: false,
        items: result.items,
        unreadCount: result.unreadCount,
        category: category,
        errorMessage: '',
      );
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(
        isLoading: false,
        errorMessage: '알림을 불러오지 못했어요.',
      );
    }
  }
}
