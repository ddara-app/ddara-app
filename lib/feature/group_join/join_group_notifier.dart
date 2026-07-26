import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/group_join_error_code.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'util/join_group_state.dart';

class JoinGroupNotifier extends AutoDisposeNotifier<JoinGroupState>
    with AutoDisposeGuard<JoinGroupState> {
  @override
  JoinGroupState build() {
    // 폐기 후 도착한 in-flight 응답이 state 를 만지지 않도록 감시를 건다.
    // (응답 전에 화면을 떠나면 dispose 된 Notifier 대입으로 StateError)
    watchDispose();

    return const JoinGroupState();
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(JoinGroupState Function(JoinGroupState state) updater) {
    if (isDisposed) return;
    state = updater(state);
  }

  void nicknameOnChanged(String nickname) {
    // 입력이 바뀌면 이전 에러를 해제한다.
    state = state.copyWith(nickname: nickname, clearErrorCode: true);
  }

  /// 초대 코드와 [state.nickname] 으로 실제 모임 참여를 요청한다.
  Future<void> joinGroup(String inviteCode) async {
    if (state.isLoading) return;

    // 요청 시작 시 이전 에러를 해제한다. (isLoading 발행으로 listen 이 다시
    // 발화할 때 남아 있던 errorCode 로 stale 토스트가 재표시되는 것을 막는다)
    state = state.copyWith(isLoading: true, clearErrorCode: true);
    final joinGroupUseCase = ref.read(joinGroupUseCaseProvider);

    try {
      final joined = await joinGroupUseCase(inviteCode, state.nickname);
      _update(
        (s) => s.copyWith(isLoading: false, joinedGroupId: joined.groupId),
      );
    } on InvalidJoinInputException {
      _update(
        (s) => s.copyWith(
          isLoading: false,
          errorCode: GroupJoinErrorCode.invalidInput,
        ),
      );
    } on InvalidInviteCodeException {
      _update(
        (s) => s.copyWith(
          isLoading: false,
          errorCode: GroupJoinErrorCode.invalidInviteCode,
        ),
      );
    } on AlreadyJoinedGroupException {
      _update(
        (s) => s.copyWith(
          isLoading: false,
          errorCode: GroupJoinErrorCode.alreadyJoinedGroup,
        ),
      );
    } on GroupFullException {
      _update(
        (s) => s.copyWith(
          isLoading: false,
          errorCode: GroupJoinErrorCode.groupFull,
        ),
      );
    } on GroupLimitExceededException {
      _update(
        (s) => s.copyWith(
          isLoading: false,
          errorCode: GroupJoinErrorCode.groupLimitExceeded,
        ),
      );
    } on DuplicateGroupNicknameException {
      _update(
        (s) => s.copyWith(
          isLoading: false,
          errorCode: GroupJoinErrorCode.duplicateGroupNickname,
        ),
      );
    } on NetworkException {
      _update(
        (s) =>
            s.copyWith(isLoading: false, errorCode: GroupJoinErrorCode.unknown),
      );
    } catch (_) {
      // 매핑되지 않은 예외(응답 파싱 실패 등)에도 isLoading 을 반드시 내려,
      // tapGuard 로 비활성화된 버튼이 영구 잠기지 않게 한다.
      _update(
        (s) =>
            s.copyWith(isLoading: false, errorCode: GroupJoinErrorCode.unknown),
      );
    }
  }
}
