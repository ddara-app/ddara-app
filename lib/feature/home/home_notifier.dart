import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/home/util/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNotifier extends AutoDisposeNotifier<HomeState> {
  @override
  HomeState build() {
    _load();
    return const HomeState(isLoading: true);
  }

  Future<void> _load() async {
    final getGroupListUseCase = ref.read(getGroupListUseCaseProvider);

    try {
      final groupList = await getGroupListUseCase();
      final blockedUserIds = await _loadBlockedUserIds();
      state = state.copyWith(
        isLoading: false,
        groups: groupList.groups,
        blockedUserIds: blockedUserIds,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: '목록을 불러오지 못했어요.');
    }
  }

  /// [userId] 유저를 차단한다. 성공하면 차단이 카드·댓글 필터에 반영되도록
  /// 홈(모임 목록 + 차단 목록)을 다시 조회하고 true 를 반환한다.
  /// (실패해도 화면 상태는 바꾸지 않는다 — 안내는 호출 측 토스트가 맡는다)
  Future<bool> blockUser(int userId) async {
    final blockUserUseCase = ref.read(blockUserUseCaseProvider);

    try {
      await blockUserUseCase(userId);
      await _load();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 내가 차단한 사용자 userId 집합을 조회한다.
  ///
  /// 차단 목록 조회가 실패해도 화면(홈)을 막지 않도록, 실패 시 빈 집합으로
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
