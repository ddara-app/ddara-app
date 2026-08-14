import 'package:ddara/core/exception/cycle_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/domain/model/group/group_action_error.dart';
import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/starter/util/starter_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StarterViewModel extends AutoDisposeNotifier<StarterState>
    with AutoDisposeGuard<StarterState> {
  @override
  StarterState build() {
    watchDispose();

    return const StarterState();
  }

  void conceptChanged(String concept) {
    state = state.copyWith(concept: concept);
  }

  /// 촬영 화면으로 전환.
  void goToCamera() {
    state = state.copyWith(step: StarterStep.camera);
  }

  /// 촬영 완료 → 촬영본을 본문(info)에 바로 반영하고 본문으로 전환.
  void capture(String path) {
    state = state.copyWith(step: StarterStep.info, photoPath: path);
  }

  /// 에러 토스트를 띄운 뒤 호출해, 같은 에러가 다시 노출되지 않게 비운다.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// 업로드 실패를 상태에 반영하고 로딩을 내린다.
  /// (업로드 중 화면을 벗어났으면 반영하지 않는다)
  void _fail(GroupActionError error) {
    if (isDisposed) return;
    state = state.copyWith(isLoading: false, error: error);
  }

  /// 촬영본을 presigned URL로 S3에 올리고 새 사이클을 시작한다.
  /// 성공하면 생성된 사이클 id 를, 실패하면 null 을 반환한다.
  /// (실패 사유는 [StarterState.error] 로 내려 화면이 토스트로 안내한다)
  ///
  /// 성공 후 이동은 일회성 이벤트라 상태에 남기지 않고 반환값으로 넘긴다 —
  /// 호출부가 결과를 받아 직접 화면을 전환한다.
  Future<int?> upload(int groupId) async {
    final photoPath = state.photoPath;
    // 촬영 전이거나 이미 전송 중이면 무시한다. (중복 전송 방지)
    if (state.isLoading || photoPath == null) return null;

    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = ref.read(starterUploadUseCase);

    try {
      final result = await useCase(groupId, state.concept, photoPath);

      // 업로드 중 화면을 벗어났으면 상태만 건드리지 않고 결과는 그대로 넘긴다.
      // (호출부가 mounted 를 확인해 이동 여부를 정한다)
      if (!isDisposed) state = state.copyWith(isLoading: false);

      return result.cycleId;
    } on InvalidStarterInputException {
      _fail(GroupActionError.starterInvalidInput);
    } on StarterImageUploadException {
      _fail(GroupActionError.imageUploadFailed);
    } on UnauthorizedException {
      _fail(GroupActionError.unauthorized);
    } on NotGroupMemberException {
      _fail(GroupActionError.notGroupMember);
    } on GroupNotFoundException {
      _fail(GroupActionError.groupNotFound);
    } on NotEnoughMembersException {
      _fail(GroupActionError.notEnoughMembers);
    } on CycleAlreadyInProgressException {
      _fail(GroupActionError.cycleAlreadyInProgress);
    } on NetworkException {
      _fail(GroupActionError.network);
    } catch (_) {
      // 위에 나열되지 않은 오류(파일 IO 실패·매퍼 캐스트 오류 등).
      // 여기서 잡지 않으면 isLoading 이 true 로 남아 로딩 오버레이가 화면을
      // 계속 덮은 채 아무것도 할 수 없게 된다.
      _fail(GroupActionError.starterUploadFailed);
    }
    return null;
  }
}
