import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/home/util/home_state.dart';
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
    return const HomeState(isLoading: true);
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(HomeState Function(HomeState state) updater) {
    if (_disposed) return;
    state = updater(state);
  }

  Future<void> _load() async {
    final getGroupListUseCase = ref.read(getGroupListUseCaseProvider);

    try {
      final groupList = await getGroupListUseCase();
      final blockedUserIds = await _loadBlockedUserIds();
      _update(
        (s) => s.copyWith(
          isLoading: false,
          groups: groupList.groups,
          blockedUserIds: blockedUserIds,
          // 이전 실패 흔적을 지운다. (에러 → 재조회 성공 시 에러 화면 잔존 방지)
          errorMessage: '',
        ),
      );
    } catch (_) {
      _update(
        (s) => s.copyWith(isLoading: false, errorMessage: '목록을 불러오지 못했어요.'),
      );
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

  /// 모임 목록·차단 목록을 다시 조회한다. (당겨서 새로고침)
  ///
  /// 이미 목록을 보고 있는 상태라, 실패해도 화면을 에러로 바꾸지 않고 보던
  /// 목록을 유지한다. (초기 조회 실패는 build 의 _load 가 처리하고, 사용자는
  /// 다시 당겨 재시도할 수 있다)
  Future<void> refresh() async {
    final getGroupListUseCase = ref.read(getGroupListUseCaseProvider);

    try {
      final groupList = await getGroupListUseCase();
      final blockedUserIds = await _loadBlockedUserIds();
      _update(
        (s) => s.copyWith(
          groups: groupList.groups,
          blockedUserIds: blockedUserIds,
          // 이전 실패 흔적을 지운다. (S-1: 성공 후 stale 에러 잔존 방지)
          errorMessage: '',
        ),
      );
    } catch (_) {
      // 보던 목록을 유지한다.
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
