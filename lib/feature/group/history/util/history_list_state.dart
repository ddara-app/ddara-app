import 'package:ddara/domain/model/group/group_action_error.dart';
import 'package:ddara/domain/model/group/history_list.dart';

/// 지난 따라찍기 목록 화면 상태. 로딩·초기 조회 실패·본문이 상호배타인 sealed 설계다.
///
/// 본문을 대체하는 초기 조회 실패는 [HistoryListLoadError] 로, 목록이 떠 있는
/// 상태의 재조회(년·월 필터) 실패는 [HistoryListLoaded.actionError] 로 분리해,
/// 한 필드가 목록 유무에 따라 본문 에러/토스트로 읽히던 암묵 규약을 타입으로
/// 대체한다.
sealed class HistoryListState {
  const HistoryListState();
}

/// 최초 조회 중. (보여줄 목록이 없어 본문 자리가 로딩)
final class HistoryListLoading extends HistoryListState {
  const HistoryListLoading();
}

/// 최초 조회 실패. (본문 자리에 문구를 띄운다)
final class HistoryListLoadError extends HistoryListState {
  const HistoryListLoadError(this.error);

  final GroupActionError error;
}

/// 목록을 그릴 수 있는 상태.
final class HistoryListLoaded extends HistoryListState {
  const HistoryListLoaded({
    required this.historyList,
    required this.blockedUserIds,
    this.actionError,
  });

  /// 지난 따라찍기(히스토리) 목록 + 통계.
  final HistoryList historyList;

  /// 내가 차단한 사용자 userId 집합.
  /// (차단한 스타터의 썸네일은 차단 자리표시로 가린다)
  final Set<int> blockedUserIds;

  /// 필터 재조회 실패 종류. (토스트용 일회성 — 문구는 화면이 l10n 으로 매핑,
  /// 소비 후 clearActionError 로 비운다)
  final GroupActionError? actionError;

  HistoryListLoaded copyWith({
    HistoryList? historyList,
    Set<int>? blockedUserIds,
    GroupActionError? actionError,
    bool clearActionError = false,
  }) {
    return HistoryListLoaded(
      historyList: historyList ?? this.historyList,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      // copyWith(actionError: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      actionError: clearActionError ? null : (actionError ?? this.actionError),
    );
  }
}
