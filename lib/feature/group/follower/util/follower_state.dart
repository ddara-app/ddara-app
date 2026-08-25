import 'package:ddara/core/exception/group_action_error.dart';

/// 따라찍기 촬영 화면 상태.
///
/// 조회형 화면(모임 상세·갤러리·히스토리)과 달리 서버에서 받아 그리는 본문이
/// 없어 sealed(Loading / LoadError / Loaded) 로 나눌 대상이 아니다. 여기의
/// [isLoading]·[error] 는 업로드 액션의 진행·실패이지 조회 상태가 아니다.
class FollowerState {
  /// 업로드 진행 중 여부. (중복 전송 방지·버튼 로딩 표시)
  final bool isLoading;

  /// 업로드 실패 종류. (문구는 화면이 l10n 으로 매핑)
  final GroupActionError? error;

  /// 진입 안내(코너 미니뷰)를 이미 본 적이 있는지. 서버에 저장되는 값이라
  /// 조회가 끝나기 전에는 null 이다. (모르는 채로 열면 본 사람에게도 다시 뜬다)
  final bool? isCornerTourSeen;

  /// 고스트 확대 안내를 이미 본 적이 있는지. 코너 미니뷰 안내와 따로 관리해,
  /// 진입 안내를 본 사용자도 고스트 확대를 처음 켤 때 그쪽 안내를 받는다.
  final bool? isGhostTourSeen;

  const FollowerState({
    this.isLoading = false,
    this.error,
    this.isCornerTourSeen,
    this.isGhostTourSeen,
  });

  FollowerState copyWith({
    bool? isLoading,
    GroupActionError? error,
    bool clearError = false,
    bool? isCornerTourSeen,
    bool? isGhostTourSeen,
  }) {
    return FollowerState(
      isLoading: isLoading ?? this.isLoading,
      // copyWith(error: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      error: clearError ? null : (error ?? this.error),
      isCornerTourSeen: isCornerTourSeen ?? this.isCornerTourSeen,
      isGhostTourSeen: isGhostTourSeen ?? this.isGhostTourSeen,
    );
  }
}
