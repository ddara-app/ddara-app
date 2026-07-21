import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/group_join_error_code.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'util/join_group_state.dart';

class JoinGroupNotifier extends AutoDisposeNotifier<JoinGroupState> {
  @override
  JoinGroupState build() {
    return const JoinGroupState();
  }

  void nicknameOnChanged(String nickname) {
    // 입력이 바뀌면 이전 에러를 해제한다.
    state = state.copyWith(nickname: nickname, clearErrorCode: true);
  }

  /// 초대 코드와 [state.nickname] 으로 실제 모임 참여를 요청한다.
  Future<void> joinGroup(String inviteCode) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    final joinGroupUseCase = ref.read(joinGroupUseCaseProvider);

    try {
      final joined = await joinGroupUseCase(
        inviteCode,
        state.nickname,
      );
      state = state.copyWith(isLoading: false, joinedGroupId: joined.groupId);
    } on InvalidJoinInputException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupJoinErrorCode.invalidInput,
      );
    } on InvalidInviteCodeException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupJoinErrorCode.invalidInviteCode,
      );
    } on AlreadyJoinedGroupException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupJoinErrorCode.alreadyJoinedGroup,
      );
    } on GroupFullException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupJoinErrorCode.groupFull,
      );
    } on GroupLimitExceededException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupJoinErrorCode.groupLimitExceeded,
      );
    } on DuplicateGroupNicknameException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupJoinErrorCode.duplicateGroupNickname,
      );
    } on NetworkException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupJoinErrorCode.unknown,
      );
    }
  }
}
