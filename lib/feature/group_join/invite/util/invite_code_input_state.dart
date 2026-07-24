import 'package:ddara/core/exception/group_join_error_code.dart';
import 'package:ddara/core/model/group/invite_group.dart';

class InviteCodeInputState {
  final String inviteCode;
  final bool isLoading;

  /// 조회된 모임 정보. 조회 전이거나 실패했으면 null.
  final InviteGroup? inviteGroup;
  final GroupJoinErrorCode? errorCode;

  const InviteCodeInputState({
    this.inviteCode = '',
    this.isLoading = false,
    this.inviteGroup,
    this.errorCode,
  });

  InviteCodeInputState copyWith({
    String? inviteCode,
    bool? isLoading,
    InviteGroup? inviteGroup,
    GroupJoinErrorCode? errorCode,
    // errorCode 를 null 로 되돌린다. (입력 변경 시 에러 해제용)
    bool clearErrorCode = false,
    // inviteGroup 을 null 로 되돌린다. (조회 시작·입력 변경 시, 재조회가
    // "prev==null → next!=null" 전환을 다시 트리거할 수 있게 한다)
    bool clearInviteGroup = false,
  }) {
    return InviteCodeInputState(
      inviteCode: inviteCode ?? this.inviteCode,
      isLoading: isLoading ?? this.isLoading,
      inviteGroup: clearInviteGroup ? null : (inviteGroup ?? this.inviteGroup),
      errorCode: clearErrorCode ? null : (errorCode ?? this.errorCode),
    );
  }
}
