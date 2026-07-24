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
    state = state.copyWith(groupName: groupName);
  }

  void descriptionOnChanged(String description) {
    state = state.copyWith(description: description);
  }

  void nicknameOnChanged(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  Future<void> createGroup() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
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
