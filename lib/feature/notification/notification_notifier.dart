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
      final blockedUserIds = await _loadBlockedUserIds();
      state = state.copyWith(
        isLoading: false,
        items: result.items,
        category: category,
        blockedUserIds: blockedUserIds,
        errorMessage: '',
      );
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(isLoading: false, errorMessage: '알림을 불러오지 못했어요.');
    }
  }

  /// 내가 차단한 사용자 userId 집합을 조회한다.
  ///
  /// 차단 목록 조회가 실패해도 화면(알림)을 막지 않도록, 실패 시 빈 집합으로
  /// 대체한다. (썸네일 가림이 한 번 빠질 뿐 치명적이지 않다)
  Future<Set<int>> _loadBlockedUserIds() async {
    try {
      final blockedUsers = await ref.read(getBlockedUsersUseCaseProvider)();
      return blockedUsers.users.map((user) => user.userId).toSet();
    } catch (_) {
      return const {};
    }
  }
}
