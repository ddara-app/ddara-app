import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:ddara/feature/profile/blocked/util/blocked_users_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockedUsersNotifier extends AutoDisposeNotifier<BlockedUsersState> {
  /// autoDispose 폐기 후 in-flight 응답이 state 를 만지지 않도록 하는 가드.
  /// (응답 전에 화면을 떠나면 dispose 된 Notifier 대입으로 StateError)
  bool _disposed = false;

  @override
  BlockedUsersState build() {
    _disposed = false; // invalidate 재빌드(같은 인스턴스) 대비 리셋.
    ref.onDispose(() => _disposed = true);
    // 진입 시 차단 목록을 조회한다. (build 는 동기라 fire-and-forget)
    _load();

    return const BlockedUsersState(isLoading: true);
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(BlockedUsersState Function(BlockedUsersState state) updater) {
    if (_disposed) return;
    state = updater(state);
  }

  Future<void> _load() async {
    final getBlockedUsersUseCase = ref.read(getBlockedUsersUseCaseProvider);

    try {
      final blockedUsers = await getBlockedUsersUseCase();
      _update((s) => s.copyWith(isLoading: false, blockedUsers: blockedUsers));
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _update(
        (s) => s.copyWith(isLoading: false, errorMessage: '차단 목록을 불러오지 못했어요.'),
      );
    }
  }

  /// [userId] 의 차단을 해제한다. 성공하면 목록을 다시 조회하고 true,
  /// 실패하면 false 를 반환한다. (요청 중엔 isLoading 으로 중복 실행을 막는다)
  Future<bool> unblock(int userId) async {
    if (state.isLoading) return false;

    _update((s) => s.copyWith(isLoading: true));
    final unblockUserUseCase = ref.read(unblockUserUseCaseProvider);

    try {
      await unblockUserUseCase(userId);
      // 해제된 결과를 반영하기 위해 목록을 다시 조회한다. (isLoading 은 _load 가 내린다)
      await _load();
      // 해제한 유저의 사진·썸네일이 다시 보이도록 홈도 재조회시킨다.
      // (홈이 스택에 남아 있으면 즉시, 없으면 다음 진입 때 반영)
      ref.invalidate(homeNotifierProvider);
      return true;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _update((s) => s.copyWith(isLoading: false));
      return false;
    }
  }
}
