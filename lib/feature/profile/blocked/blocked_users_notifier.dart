import 'package:ddara/core/model/block/blocked_users.dart';
import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/feature/profile/blocked/util/blocked_users_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockedUsersNotifier extends AutoDisposeNotifier<BlockedUsersState>
    with AutoDisposeGuard<BlockedUsersState> {
  @override
  BlockedUsersState build() {
    // 폐기 후 도착한 in-flight 응답이 state 를 만지지 않도록 감시를 건다.
    // (응답 전에 화면을 떠나면 dispose 된 Notifier 대입으로 StateError)
    watchDispose();
    // 진입 시 차단 목록을 조회한다. (build 는 동기라 fire-and-forget)
    _load();

    return const BlockedUsersState(isLoading: true);
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(BlockedUsersState Function(BlockedUsersState state) updater) {
    if (isDisposed) return;
    state = updater(state);
  }

  Future<void> _load() async {
    final getBlockedUsersUseCase = ref.read(getBlockedUsersUseCaseProvider);

    try {
      final blockedUsers = await getBlockedUsersUseCase();
      _update((s) => s.copyWith(isLoading: false, blockedUsers: blockedUsers));
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      // (blockedUsers 가 null 로 남아 화면이 조회 실패 안내를 표시한다)
      _update((s) => s.copyWith(isLoading: false));
    }
  }

  /// [userId] 의 차단을 해제한다. 성공하면 해당 항목만 목록에서 빼고 true,
  /// 실패하면 false 를 반환한다. 진행 중엔 그 userId 를 [unblockingUserIds] 에
  /// 담아(같은 항목) 중복 실행을 막고, 목록 전체를 스피너로 가리지 않는다.
  Future<bool> unblock(int userId) async {
    if (state.unblockingUserIds.contains(userId)) return false;

    _update(
      (s) => s.copyWith(unblockingUserIds: {...s.unblockingUserIds, userId}),
    );
    final unblockUserUseCase = ref.read(unblockUserUseCaseProvider);

    try {
      await unblockUserUseCase(userId);
      // 재조회 왕복 없이 해제한 항목만 목록에서 제거한다.
      _update((s) {
        final users = s.blockedUsers?.users
            .where((user) => user.userId != userId)
            .toList();
        return s.copyWith(
          blockedUsers: users == null ? null : BlockedUsers(users: users),
          unblockingUserIds: _without(s.unblockingUserIds, userId),
        );
      });
      // 해제한 유저의 사진·썸네일이 다시 보이도록 홈도 재조회시킨다.
      // (홈이 스택에 남아 있으면 즉시, 없으면 다음 진입 때 반영)
      ref.invalidate(homeNotifierProvider);
      return true;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _update(
        (s) => s.copyWith(
          unblockingUserIds: _without(s.unblockingUserIds, userId),
        ),
      );
      return false;
    }
  }

  /// [set] 에서 [userId] 를 뺀 새 집합을 반환한다. (원본 불변 유지)
  Set<int> _without(Set<int> set, int userId) => {...set}..remove(userId);
}
