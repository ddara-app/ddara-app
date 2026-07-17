import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/profile/blocked/util/blocked_users_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockedUsersNotifier extends AutoDisposeNotifier<BlockedUsersState> {
  @override
  BlockedUsersState build() {
    // 진입 시 차단 목록을 조회한다. (build 는 동기라 fire-and-forget)
    _load();

    return const BlockedUsersState(isLoading: true);
  }

  Future<void> _load() async {
    final getBlockedUsersUseCase = ref.read(getBlockedUsersUseCaseProvider);

    try {
      final blockedUsers = await getBlockedUsersUseCase();
      state = state.copyWith(isLoading: false, blockedUsers: blockedUsers);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(
        isLoading: false,
        errorMessage: '차단 목록을 불러오지 못했어요.',
      );
    }
  }
}
