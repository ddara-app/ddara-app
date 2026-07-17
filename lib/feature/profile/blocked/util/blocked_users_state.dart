import 'package:ddara/core/model/block/blocked_users.dart';

class BlockedUsersState {
  /// 차단한 유저 목록. 조회 전엔 null.
  final BlockedUsers? blockedUsers;

  /// 목록 조회 중 여부.
  final bool isLoading;

  /// 조회 실패 메시지. 비어 있으면 에러 없음.
  final String errorMessage;

  const BlockedUsersState({
    this.blockedUsers,
    this.isLoading = false,
    this.errorMessage = '',
  });

  BlockedUsersState copyWith({
    BlockedUsers? blockedUsers,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BlockedUsersState(
      blockedUsers: blockedUsers ?? this.blockedUsers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
