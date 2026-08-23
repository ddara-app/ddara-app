import 'dart:async' show unawaited;

import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/notification/util/notification_state.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationViewModel extends AutoDisposeNotifier<NotificationState>
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

  /// 조회에 실패한 뒤 다시 불러온다. (안내 화면의 '다시 시도')
  void retry() {
    _update((_) => const NotificationLoading());
    _load();
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

  /// [notificationId] 알림을 읽음으로 표시한다.
  ///
  /// 목록은 건드리지 않는다. 누르면 바로 다른 화면으로 이동하면서 이 화면이
  /// 폐기되고, 돌아올 때는 서버에서 다시 조회하기 때문이다.
  ///
  /// 서버 응답을 기다리지 않고, 실패해도 화면에 알리지 않는다.
  /// 다음 조회 때 안 읽음으로 남을 뿐이다.
  void markAsRead(int notificationId) {
    final current = state;
    if (current is! NotificationLoaded) return;

    // 목록에 없거나(재조회로 사라짐) 이미 읽은 알림이면 부르지 않는다.
    final index = current.items.indexWhere((item) => item.id == notificationId);
    if (index < 0 || current.items[index].isRead) return;

    unawaited(_sendRead(notificationId));
  }

  Future<void> _sendRead(int notificationId) async {
    try {
      await ref.read(markNotificationAsReadUseCaseProvider)(notificationId);
    } catch (e) {
      debugPrint('[Notification] 읽음 처리 실패(id=$notificationId): $e');
    }
  }
}
