import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/home/util/home_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNotifier extends AutoDisposeNotifier<HomeState> {
  /// autoDispose 폐기 후 in-flight 응답이 state 를 만지지 않도록 하는 가드.
  /// (홈 진입 직후 로그아웃 등으로 폐기된 뒤 응답이 도착하면 StateError)
  bool _disposed = false;

  @override
  HomeState build() {
    _disposed = false; // invalidate 재빌드(같은 인스턴스) 대비 리셋.
    ref.onDispose(() => _disposed = true);
    _load();
    return const HomeLoading();
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(HomeState Function(HomeState state) updater) {
    if (_disposed) return;
    state = updater(state);
  }

  /// 모임 목록·차단 목록을 조회해 상태를 확정한다.
  ///
  /// 실패 시: 이미 목록을 보고 있으면(재조회) 보던 목록을 유지하고,
  /// 아직 로드 전이면 본문 에러로 전환한다.
  Future<void> _load() async {
    final getGroupListUseCase = ref.read(getGroupListUseCaseProvider);

    try {
      // 서로 의존 없는 두 조회를 병렬로 기다린다. (초기 로딩 체감 단축 —
      // 차단 목록 조회는 내부에서 실패를 삼키므로 실패는 목록 조회 쪽뿐이다)
      final (groupList, blockedUserIds) = await (
        getGroupListUseCase(),
        _loadBlockedUserIds(),
      ).wait;
      _update(
        (_) => HomeLoaded(
          groups: groupList.groups,
          blockedUserIds: blockedUserIds,
        ),
      );
    } catch (e) {
      debugPrint('[Home] 목록 조회 실패: $e');
      _update((s) => s is HomeLoaded ? s : const HomeLoadError());
    }
  }

  /// [userId] 유저를 [groupId] 모임 맥락에서 차단한다. 성공하면 차단이
  /// 카드·댓글 필터에 반영되도록 홈(모임 목록 + 차단 목록)을 다시 조회하고
  /// true 를 반환한다.
  /// (실패해도 화면 상태는 바꾸지 않는다 — 안내는 호출 측 토스트가 맡는다)
  Future<bool> blockUser(int userId, {required int groupId}) async {
    final blockUserUseCase = ref.read(blockUserUseCaseProvider);

    try {
      await blockUserUseCase(userId, groupId: groupId);
      await _load();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 모임 목록·차단 목록을 다시 조회한다. (당겨서 새로고침)
  /// 실패 시 보던 목록 유지는 [_load] 가 처리한다.
  Future<void> refresh() => _load();

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
