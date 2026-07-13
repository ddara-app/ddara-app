import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/history/util/history_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryListNotifier
    extends AutoDisposeFamilyNotifier<HistoryListState, int> {
  @override
  HistoryListState build(int groupId) {
    // 진입 시 groupId 로 히스토리 목록을 조회한다. (build 는 동기라 fire-and-forget)
    _load(groupId);

    return const HistoryListState(isLoading: true);
  }

  Future<void> _load(int groupId) async {
    final getHistoryCyclesUseCase = ref.read(getHistoryCyclesUseCaseProvider);

    try {
      final historyCycles = await getHistoryCyclesUseCase(groupId);
      state = state.copyWith(isLoading: false, historyCycles: historyCycles);
    } on NotGroupMemberException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '해당 모임의 멤버가 아니에요.',
      );
    } on GroupNotFoundException {
      state = state.copyWith(isLoading: false, errorMessage: '존재하지 않는 모임이에요.');
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(
        isLoading: false,
        errorMessage: '지난 따라찍기를 불러오지 못했어요.',
      );
    }
  }
}
