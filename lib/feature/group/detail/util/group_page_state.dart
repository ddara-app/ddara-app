import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/core/model/group/history_cycles.dart';

class GroupPageState {
  final GroupDetail? groupDetail;

  /// 지난 따라찍기(히스토리) 목록. 조회 전엔 null.
  final HistoryCycles? historyCycles;
  final bool isLoading;
  final String errorMessage;

  const GroupPageState({
    this.groupDetail,
    this.historyCycles,
    this.isLoading = false,
    this.errorMessage = '',
  });

  GroupPageState copyWith({
    GroupDetail? groupDetail,
    HistoryCycles? historyCycles,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GroupPageState(
      groupDetail: groupDetail ?? this.groupDetail,
      historyCycles: historyCycles ?? this.historyCycles,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
