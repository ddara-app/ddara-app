import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/notification/util/notification_state.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationNotifier extends AutoDisposeNotifier<NotificationState>
    with AutoDisposeGuard<NotificationState> {
  @override
  NotificationState build() {
    // 폐기 후 도착한 in-flight 응답이 state 를 만지지 않도록 감시를 건다.
    // (조회 중 뒤로가기로 페이지를 pop 하면 폐기된 뒤 응답이 도착해 StateError)
    watchDispose();
    // 진입 시 전체 알림을 조회한다. (build 는 동기라 fire-and-forget)
    _load();

    return const NotificationLoading();
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(NotificationState Function(NotificationState state) updater) {
    if (isDisposed) return;
    state = updater(state);
  }

  Future<void> _load() async {
    final getNotifications = ref.read(getNotificationsUseCaseProvider);

    try {
      final result = await getNotifications();
      final blockedUserIds = await ref.read(getBlockedUserIdsUseCaseProvider)();
      _update(
        (_) => NotificationLoaded(
          items: result.items,
          blockedUserIds: blockedUserIds,
        ),
      );
    } catch (e) {
      // NetworkException 및 기타 예기치 못한 오류. (매퍼 버그 등 프로그래밍
      // 오류도 화면을 막지 않도록 여기서 잡되, 단서가 사라지지 않게 로깅한다)
      debugPrint('[Notification] 알림 조회 실패: $e');
      // 이미 목록을 보고 있으면 유지하고, 아직 로드 전이면 에러 화면으로 전환한다.
      _update(
        (s) => s is NotificationLoaded ? s : const NotificationLoadError(),
      );
    }
  }
}
