import 'package:ddara/core/model/group/history_cycles.dart';

class HistoryListState {
  /// 지난 따라찍기(히스토리) 목록. 조회 전엔 null.
  final HistoryCycles? historyCycles;

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 스타터의 썸네일은 차단 자리표시로 가린다)
  final Set<int> blockedUserIds;

  /// 목록 조회 중 여부.
  final bool isLoading;

  /// 조회 실패 메시지. 비어 있으면 에러 없음.
  final String errorMessage;

  const HistoryListState({
    this.historyCycles,
    this.blockedUserIds = const {},
    this.isLoading = false,
    this.errorMessage = '',
  });

  HistoryListState copyWith({
    HistoryCycles? historyCycles,
    Set<int>? blockedUserIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HistoryListState(
      historyCycles: historyCycles ?? this.historyCycles,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
