import 'package:ddara/core/model/block/blocked_users.dart';

class BlockedUsersState {
  /// 차단한 유저 목록. 조회 전(또는 실패)엔 null — 로딩이 끝났는데 null 이면
  /// 화면이 조회 실패 안내(l10n)를 표시한다.
  final BlockedUsers? blockedUsers;

  /// 목록 조회 중 여부.
  final bool isLoading;

  const BlockedUsersState({this.blockedUsers, this.isLoading = false});

  BlockedUsersState copyWith({BlockedUsers? blockedUsers, bool? isLoading}) {
    return BlockedUsersState(
      blockedUsers: blockedUsers ?? this.blockedUsers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
