import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/notification/util/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationNotifier extends AutoDisposeNotifier<NotificationState> {
  @override
  NotificationState build() {
    // 진입 시 전체 알림을 조회한다. (build 는 동기라 fire-and-forget)
    _load();
    return const NotificationState(isLoading: true);
  }

  Future<void> _load() async {
    final getNotifications = ref.read(getNotificationsUseCaseProvider);

    try {
      final result = await getNotifications();
      final blockedUserIds = await ref.read(getBlockedUserIdsUseCaseProvider)();
      state = state.copyWith(
        isLoading: false,
        items: result.items,
        blockedUserIds: blockedUserIds,
        errorMessage: '',
      );
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(isLoading: false, errorMessage: '알림을 불러오지 못했어요.');
    }
  }
}
