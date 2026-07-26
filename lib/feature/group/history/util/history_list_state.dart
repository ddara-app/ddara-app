import 'package:ddara/core/model/group/group_action_error.dart';
import 'package:ddara/core/model/group/history_list.dart';

class HistoryListState {
  /// 지난 따라찍기(히스토리) 목록 + 통계. 조회 전엔 null.
  final HistoryList? historyList;

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 스타터의 썸네일은 차단 자리표시로 가린다)
  final Set<int> blockedUserIds;

  /// 목록 조회 중 여부.
  final bool isLoading;

  /// 조회 실패 종류. (문구는 화면이 l10n 으로 매핑)
  final GroupActionError? error;

  const HistoryListState({
    this.historyList,
    this.blockedUserIds = const {},
    this.isLoading = false,
    this.error,
  });

  HistoryListState copyWith({
    HistoryList? historyList,
    Set<int>? blockedUserIds,
    bool? isLoading,
    GroupActionError? error,
    bool clearError = false,
  }) {
    return HistoryListState(
      historyList: historyList ?? this.historyList,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      isLoading: isLoading ?? this.isLoading,
      // copyWith(error: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      error: clearError ? null : (error ?? this.error),
    );
  }
}
