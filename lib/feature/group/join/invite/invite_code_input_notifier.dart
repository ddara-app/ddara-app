import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/join/util/invite_code_input_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/group_join_error_code.dart';
import 'package:ddara/core/exception/login_exception.dart';

class InviteCodeInputNotifier
    extends AutoDisposeNotifier<InviteCodeInputState> {
  @override
  InviteCodeInputState build() {
    return InviteCodeInputState();
  }

  void inviteCodeOnChanged(String inviteCode) {
    // 입력이 바뀌면 이전 에러를 해제한다.
    state = state.copyWith(inviteCode: inviteCode, clearErrorCode: true);
  }

  Future<void> joinGroup() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    final getInviteGroupUseCase = ref.read(getInviteGroupUseCaseProvider);

    try {
      final inviteGroup = await getInviteGroupUseCase(
        state.inviteCode,
      );

      // 조회는 됐지만 참여할 수 없는 경우(이미 참여 중·정원 초과)를 걸러낸다.
      if (inviteGroup.alreadyJoined) {
        state = state.copyWith(
          isLoading: false,
          errorCode: GroupJoinErrorCode.alreadyJoinedGroup,
        );
        return;
      }
      if (inviteGroup.isFull) {
        state = state.copyWith(
          isLoading: false,
          errorCode: GroupJoinErrorCode.groupFull,
        );
        return;
      }

      state = state.copyWith(isLoading: false, inviteGroup: inviteGroup);
    } on InvalidInviteCodeException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupJoinErrorCode.invalidInviteCode,
      );
    } on NetworkException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupJoinErrorCode.unknown,
      );
    }
  }
}
