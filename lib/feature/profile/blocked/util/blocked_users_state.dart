import 'package:ddara/core/model/block/blocked_users.dart';

class BlockedUsersState {
  /// 차단한 유저 목록. 조회 전(또는 실패)엔 null — 로딩이 끝났는데 null 이면
  /// 화면이 조회 실패 안내(l10n)를 표시한다.
  final BlockedUsers? blockedUsers;

  /// 최초 목록 조회 중 여부. (개별 차단 해제 진행은 [unblockingUserIds] 로 구분)
  final bool isLoading;

  /// 차단 해제가 진행 중인 userId 집합. 해당 항목의 버튼만 로딩 표시하고,
  /// 목록 전체를 스피너로 가리지 않기 위해 [isLoading] 과 분리한다.
  final Set<int> unblockingUserIds;

  const BlockedUsersState({
    this.blockedUsers,
    this.isLoading = false,
    this.unblockingUserIds = const {},
  });

  BlockedUsersState copyWith({
    BlockedUsers? blockedUsers,
    bool? isLoading,
    Set<int>? unblockingUserIds,
  }) {
    return BlockedUsersState(
      blockedUsers: blockedUsers ?? this.blockedUsers,
      isLoading: isLoading ?? this.isLoading,
      unblockingUserIds: unblockingUserIds ?? this.unblockingUserIds,
    );
  }
}
