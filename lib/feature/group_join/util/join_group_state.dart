import 'package:ddara/core/exception/group_join_error_code.dart';

class JoinGroupState {
  /// 모임에서 사용할 닉네임 입력값.
  final String nickname;

  final bool isLoading;

  /// 참여 완료된 모임 id. (참여 전·실패 시 -1)
  final int joinedGroupId;

  /// 참여 실패 에러 코드. (없으면 null)
  final GroupJoinErrorCode? errorCode;

  const JoinGroupState({
    this.nickname = '',
    this.isLoading = false,
    this.joinedGroupId = -1,
    this.errorCode,
  });

  JoinGroupState copyWith({
    String? nickname,
    bool? isLoading,
    int? joinedGroupId,
    GroupJoinErrorCode? errorCode,
    // errorCode 를 null 로 되돌린다. (입력 변경 시 에러 해제용)
    bool clearErrorCode = false,
  }) {
    return JoinGroupState(
      nickname: nickname ?? this.nickname,
      isLoading: isLoading ?? this.isLoading,
      joinedGroupId: joinedGroupId ?? this.joinedGroupId,
      errorCode: clearErrorCode ? null : (errorCode ?? this.errorCode),
    );
  }
}
