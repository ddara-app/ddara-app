import 'package:ddara/core/model/group/group_action_error.dart';

class FollowerState {
  /// 업로드 진행 중 여부. (중복 전송 방지·버튼 로딩 표시)
  final bool isLoading;

  /// 업로드 실패 종류. (문구는 화면이 l10n 으로 매핑)
  final GroupActionError? error;

  const FollowerState({this.isLoading = false, this.error});

  FollowerState copyWith({
    bool? isLoading,
    GroupActionError? error,
    bool clearError = false,
  }) {
    return FollowerState(
      isLoading: isLoading ?? this.isLoading,
      // copyWith(error: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      error: clearError ? null : (error ?? this.error),
    );
  }
}
