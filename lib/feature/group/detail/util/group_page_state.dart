import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/model/group/history_cycles.dart';

class GroupPageState {
  final GroupDetail? groupDetail;

  /// 지난 따라찍기(히스토리) 목록. 조회 전엔 null.
  final HistoryCycles? historyCycles;

  /// 내가 차단한 사용자 userId 집합. (차단한 멤버의 사진을 가리는 데 사용)
  final Set<int> blockedUserIds;

  final bool isLoading;
  final String errorMessage;

  const GroupPageState({
    this.groupDetail,
    this.historyCycles,
    this.blockedUserIds = const {},
    this.isLoading = false,
    this.errorMessage = '',
  });

  GroupPageState copyWith({
    GroupDetail? groupDetail,
    HistoryCycles? historyCycles,
    Set<int>? blockedUserIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GroupPageState(
      groupDetail: groupDetail ?? this.groupDetail,
      historyCycles: historyCycles ?? this.historyCycles,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
