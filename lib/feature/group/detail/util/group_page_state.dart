import 'package:ddara/core/model/group/group_action_error.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/model/group/history_cycles.dart';

class GroupPageState {
  final GroupDetail? groupDetail;

  /// 지난 따라찍기(히스토리) 목록. 조회 전엔 null.
  final HistoryCycles? historyCycles;

  /// 내가 차단한 사용자 userId 집합. (차단한 멤버의 사진을 가리는 데 사용)
  final Set<int> blockedUserIds;

  final bool isLoading;

  /// 액션 실패 종류. (토스트용 일회성 — 문구는 화면이 l10n 으로 매핑,
  /// 소비 후 clearError 로 비운다)
  final GroupActionError? error;

  const GroupPageState({
    this.groupDetail,
    this.historyCycles,
    this.blockedUserIds = const {},
    this.isLoading = false,
    this.error,
  });

  GroupPageState copyWith({
    GroupDetail? groupDetail,
    HistoryCycles? historyCycles,
    Set<int>? blockedUserIds,
    bool? isLoading,
    GroupActionError? error,
    bool clearError = false,
  }) {
    return GroupPageState(
      groupDetail: groupDetail ?? this.groupDetail,
      historyCycles: historyCycles ?? this.historyCycles,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      isLoading: isLoading ?? this.isLoading,
      // copyWith(error: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      error: clearError ? null : (error ?? this.error),
    );
  }
}
