import 'package:ddara/core/exception/cycle_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/starter/util/starter_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StarterNotifier extends AutoDisposeNotifier<StarterState> {
  @override
  StarterState build() {
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
    state = state.copyWith(
      step: StarterStep.info,
      photoPath: path,
    );
  }

  /// 에러 토스트를 띄운 뒤 호출해, 같은 에러가 다시 노출되지 않게 비운다.
  void clearError() {
    state = state.copyWith(errorMessage: '');
  }

  /// 촬영본을 presigned URL로 S3에 올리고 새 사이클을 시작한다.
  /// 성공 시 [StarterState.uploadedCycleId] 에 생성된 사이클 id 를 담는다.
  Future<void> upload(int groupId) async {
    final photoPath = state.photoPath;
    // 촬영 전이거나 이미 전송 중이면 무시한다. (중복 전송 방지)
    if (state.isLoading || photoPath == null) return;

    state = state.copyWith(isLoading: true, errorMessage: '');
    final useCase = ref.read(starterUploadUseCase);

    try {
      final result = await useCase(
        groupId,
        state.concept,
        photoPath,
      );

      state = state.copyWith(
        isLoading: false,
        uploadedCycleId: result.cycleId,
      );
    } on InvalidStarterInputException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '컨셉 또는 이미지가 올바르지 않습니다.',
      );
    } on StarterImageUploadException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '이미지 업로드에 실패했습니다.',
      );
    } on UnauthorizedException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인이 필요합니다.',
      );
    } on NotGroupMemberException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '모임 멤버가 아닙니다.',
      );
    } on GroupNotFoundException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '존재하지 않는 모임입니다.',
      );
    } on NotEnoughMembersException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '활동 멤버가 3명 이상이어야 시작할 수 있어요.',
      );
    } on CycleAlreadyInProgressException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '이미 진행 중인 회차가 있어요.',
      );
    } on NetworkException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '네트워크 연결이 불안정합니다.',
      );
    }
  }
}
