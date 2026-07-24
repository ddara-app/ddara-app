import 'package:ddara/core/exception/group_create_error.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group_create/util/create_group_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/exception/group_exception.dart';
import '../../core/exception/login_exception.dart';

class CreateGroupNotifier extends AutoDisposeNotifier<CreateGroupState> {
  @override
  CreateGroupState build() {
    return CreateGroupState();
  }

  void groupNameOnChanged(String groupName) {
    // 입력이 바뀌면 이전 에러를 해제한다. (실패 후 키 입력마다 토스트 재표시 방지)
    state = state.copyWith(groupName: groupName, clearErrorCode: true);
  }

  void descriptionOnChanged(String description) {
    state = state.copyWith(description: description, clearErrorCode: true);
  }

  void nicknameOnChanged(String nickname) {
    state = state.copyWith(nickname: nickname, clearErrorCode: true);
  }

  Future<void> createGroup() async {
    if (state.isLoading) return;

    // 요청 시작 시 이전 에러를 해제한다. (isLoading 발행으로 listen 이 다시
    // 발화할 때 남아 있던 에러로 stale 토스트가 재표시되는 것을 막는다)
    state = state.copyWith(isLoading: true, clearErrorCode: true);
    final createGroupUseCase = ref.read(createGroupUseCaseProvider);

    try {
      final createGroup = await createGroupUseCase(
        state.groupName,
        state.description,
        state.nickname,
      );

      state = state.copyWith(isLoading: false);
      state = state.copyWith(createGroupId: createGroup.groupId);
    } on InvalidGroupNameException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupCreateError.invalidName,
      );
    } on UnauthorizedException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupCreateError.unauthorized,
      );
    } on GroupLimitExceededException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupCreateError.limitExceeded,
      );
    } on NetworkException {
      state = state.copyWith(
        isLoading: false,
        errorCode: GroupCreateError.unknown,
      );
    }
  }
}
