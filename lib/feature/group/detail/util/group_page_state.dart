import 'package:ddara/core/exception/group_action_error.dart';
import 'package:ddara/domain/model/group/group_detail.dart';
import 'package:ddara/domain/model/group/history_cycles.dart';

/// 모임 상세 화면 상태. 로딩·초기 조회 실패·본문이 상호배타인 sealed 설계다.
///
/// 본문을 대체하는 초기 조회 실패는 [GroupPageLoadError] 로, 본문이 떠 있는
/// 상태의 액션(나가기·차단·닉네임 변경·신고·재조회) 실패는
/// [GroupPageLoaded.actionError] 로 분리해, 한 필드가 본문 유무에 따라 본문
/// 에러/토스트로 읽히던 암묵 규약을 타입으로 대체한다.
sealed class GroupPageState {
  const GroupPageState();
}

/// 최초 조회 중. (보여줄 본문이 없어 화면 전체가 로딩)
final class GroupPageLoading extends GroupPageState {
  const GroupPageLoading();
}

/// 최초 조회 실패. (본문 자리에 문구를 띄우고 당겨서 재시도)
final class GroupPageLoadError extends GroupPageState {
  const GroupPageLoadError(this.error);

  final GroupActionError error;
}

/// 상세를 그릴 수 있는 상태.
final class GroupPageLoaded extends GroupPageState {
  const GroupPageLoaded({
    required this.groupDetail,
    required this.historyCycles,
    required this.blockedUserIds,
    this.isBusy = false,
    this.actionError,
  });

  final GroupDetail groupDetail;

  /// 지난 따라찍기(히스토리) 목록. 상세와 함께 조회한다.
  final HistoryCycles historyCycles;

  /// 내가 차단한 사용자 userId 집합. (차단한 멤버의 사진을 가리는 데 사용)
  final Set<int> blockedUserIds;

  /// 나가기·차단·닉네임 변경 처리 중 여부.
  /// (본문은 그대로 두고 로딩 오버레이로 덮어 스크롤 위치를 유지한다)
  final bool isBusy;

  /// 액션 실패 종류. (토스트용 일회성 — 문구는 화면이 l10n 으로 매핑,
  /// 소비 후 clearActionError 로 비운다)
  final GroupActionError? actionError;

  GroupPageLoaded copyWith({
    GroupDetail? groupDetail,
    HistoryCycles? historyCycles,
    Set<int>? blockedUserIds,
    bool? isBusy,
    GroupActionError? actionError,
    bool clearActionError = false,
  }) {
    return GroupPageLoaded(
      groupDetail: groupDetail ?? this.groupDetail,
      historyCycles: historyCycles ?? this.historyCycles,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      isBusy: isBusy ?? this.isBusy,
      // copyWith(actionError: null) 은 기존 값을 유지하므로 리셋은 clear 로만.
      actionError: clearActionError ? null : (actionError ?? this.actionError),
    );
  }
}
