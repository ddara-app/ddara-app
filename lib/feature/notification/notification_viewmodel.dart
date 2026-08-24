import 'dart:async' show unawaited;

import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/notification/provider/unread_notification_provider.dart';
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
  /// 목록도 함께 읽음으로 바꾼다. 알림을 눌러 이동해도 이 화면은 스택에 남아
  /// 있어(알림 > 상세), 뒤로 돌아왔을 때 다시 조회하지 않기 때문이다.
  /// (docs/tech_notes/notification_navigation.md)
  ///
  /// 서버 응답은 기다리지 않는다. 실패해도 화면에 알리거나 되돌리지 않고,
  /// 다음 조회 때 안 읽음으로 남을 뿐이다.
  void markAsRead(int notificationId) {
    final current = state;
    if (current is! NotificationLoaded) return;

    // 목록에 없거나(재조회로 사라짐) 이미 읽은 알림이면 부르지 않는다.
    final index = current.items.indexWhere((item) => item.id == notificationId);
    if (index < 0 || current.items[index].isRead) return;

    final items = [...current.items];
    items[index] = items[index].copyWith(readAt: DateTime.now());
    _update(
      (s) => s is NotificationLoaded
          ? NotificationLoaded(
              items: items,
              blockedUserIds: s.blockedUserIds,
            )
          : s,
    );

    unawaited(_sendRead(notificationId));
  }

  Future<void> _sendRead(int notificationId) async {
    try {
      await ref.read(markNotificationAsReadUseCaseProvider)(notificationId);
      // 홈 종 아이콘을 다시 판정하게 한다. 이 화면이 폐기된 뒤에도
      // 홈은 그대로 떠 있어, 목록에서 바로 다른 화면으로 넘어가도 반영된다.
      ref.invalidate(hasUnreadNotificationProvider);
    } catch (e) {
      debugPrint('[Notification] 읽음 처리 실패(id=$notificationId): $e');
    }
  }
}
