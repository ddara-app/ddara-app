import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/notification/util/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationNotifier extends AutoDisposeNotifier<NotificationState> {
  /// autoDispose 폐기 후 in-flight 응답이 state 를 만지지 않도록 하는 가드.
  /// (조회 중 뒤로가기로 페이지를 pop 하면 폐기된 뒤 응답이 도착해 StateError)
  bool _disposed = false;

  @override
  NotificationState build() {
    _disposed = false; // invalidate 재빌드(같은 인스턴스) 대비 리셋.
    ref.onDispose(() => _disposed = true);
    // 진입 시 전체 알림을 조회한다. (build 는 동기라 fire-and-forget)
    _load();
    return const NotificationState(isLoading: true);
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(NotificationState Function(NotificationState state) updater) {
    if (_disposed) return;
    state = updater(state);
  }

  Future<void> _load() async {
    final getNotifications = ref.read(getNotificationsUseCaseProvider);

    try {
      final result = await getNotifications();
      final blockedUserIds = await ref.read(getBlockedUserIdsUseCaseProvider)();
      _update(
        (s) => s.copyWith(
          isLoading: false,
          items: result.items,
          blockedUserIds: blockedUserIds,
          hasError: false,
        ),
      );
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _update((s) => s.copyWith(isLoading: false, hasError: true));
    }
  }
}
