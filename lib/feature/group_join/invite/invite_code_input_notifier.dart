import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group_join/invite/util/invite_code_input_state.dart';
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
    // 입력이 바뀌면 이전 에러와 조회 결과를 함께 해제한다.
    // (코드를 고쳤는데 이전 코드의 조회 결과가 남아 잘못 전환되는 것을 막는다)
    state = state.copyWith(
      inviteCode: inviteCode,
      clearErrorCode: true,
      clearInviteGroup: true,
    );
  }

  Future<void> joinGroup() async {
    if (state.isLoading) return;

    // 조회 시작 시 이전 결과를 비운다. 조회 성공 화면(참여 확인)에서 뒤로
    // 돌아와 다시 조회해도 "prev==null → next!=null" 전환이 다시 트리거된다.
    state = state.copyWith(isLoading: true, clearInviteGroup: true);
    final getInviteGroupUseCase = ref.read(getInviteGroupUseCaseProvider);

    try {
      final inviteGroup = await getInviteGroupUseCase(state.inviteCode);

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
