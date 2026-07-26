import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/model/group/group_action_error.dart';
import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/history/util/history_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryListNotifier
    extends AutoDisposeFamilyNotifier<HistoryListState, int>
    with AutoDisposeGuard<HistoryListState> {
  /// 가장 마지막에 시작한 조회의 번호. 응답이 도착했을 때 이 값과 다르면
  /// 그 사이 새 조회가 시작된 것이므로 결과를 버린다.
  /// (필터를 빠르게 바꿀 때 옛 응답이 최신 목록을 덮는 것을 막는다)
  int _requestId = 0;

  @override
  HistoryListState build(int groupId) {
    watchDispose();
    // 진입 시 groupId 로 히스토리 목록을 조회한다. (build 는 동기라 fire-and-forget)
    _load(groupId);

    return const HistoryListState(isLoading: true);
  }

  /// 연·월 필터를 적용해 목록을 다시 조회한다.
  /// (전체보기는 year·month 를 모두 null 로 호출)
  Future<void> applyFilter({int? year, int? month}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _load(arg, year: year, month: month);
  }

  Future<void> _load(int groupId, {int? year, int? month}) async {
    final id = ++_requestId;
    final getHistoryListUseCase = ref.read(getHistoryListUseCaseProvider);

    try {
      final historyList = await getHistoryListUseCase(
        groupId,
        year: year,
        month: month,
      );
      final blockedUserIds = await ref.read(getBlockedUserIdsUseCaseProvider)();
      // 화면을 벗어났거나(폐기) 더 새 조회가 시작됐으면 이 결과는 버린다.
      if (isDisposed || id != _requestId) return;
      state = state.copyWith(
        isLoading: false,
        historyList: historyList,
        blockedUserIds: blockedUserIds,
      );
    } on NotGroupMemberException {
      _fail(id, GroupActionError.notGroupMember);
    } on GroupNotFoundException {
      _fail(id, GroupActionError.groupNotFound);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _fail(id, GroupActionError.historyLoadFailed);
    }
  }

  /// 조회 실패를 상태에 반영한다. 폐기됐거나 이미 더 새 조회가 시작됐다면
  /// 무시한다 — 옛 요청의 실패로 최신 조회의 로딩·목록이 흐트러지지 않게 한다.
  void _fail(int id, GroupActionError error) {
    if (isDisposed || id != _requestId) return;
    state = state.copyWith(isLoading: false, error: error);
  }
}
