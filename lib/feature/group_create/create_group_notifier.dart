import 'package:ddara/core/exception/group_create_error.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group_create/util/create_group_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/exception/group_exception.dart';
import '../../core/exception/login_exception.dart';

class CreateGroupNotifier extends AutoDisposeNotifier<CreateGroupState> {
  /// autoDispose 폐기 후 in-flight 응답이 state 를 만지지 않도록 하는 가드.
  /// (응답 전에 화면을 떠나면 dispose 된 Notifier 대입으로 StateError)
  bool _disposed = false;

  @override
  CreateGroupState build() {
    _disposed = false; // invalidate 재빌드(같은 인스턴스) 대비 리셋.
    ref.onDispose(() => _disposed = true);
    return CreateGroupState();
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(CreateGroupState Function(CreateGroupState state) updater) {
    if (_disposed) return;
    state = updater(state);
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

      _update(
        (s) => s.copyWith(isLoading: false, createGroupId: createGroup.groupId),
      );
    } on InvalidGroupNameException {
      _update(
        (s) => s.copyWith(
          isLoading: false,
          errorCode: GroupCreateError.invalidName,
        ),
      );
    } on UnauthorizedException {
      _update(
        (s) => s.copyWith(
          isLoading: false,
          errorCode: GroupCreateError.unauthorized,
        ),
      );
    } on GroupLimitExceededException {
      _update(
        (s) => s.copyWith(
          isLoading: false,
          errorCode: GroupCreateError.limitExceeded,
        ),
      );
    } on NetworkException {
      _update(
        (s) =>
            s.copyWith(isLoading: false, errorCode: GroupCreateError.unknown),
      );
    } catch (_) {
      // 매핑되지 않은 예외(응답 파싱 실패 등)에도 isLoading 을 반드시 내려,
      // tapGuard 로 비활성화된 버튼이 영구 잠기지 않게 한다.
      _update(
        (s) =>
            s.copyWith(isLoading: false, errorCode: GroupCreateError.unknown),
      );
    }
  }
}
