import 'package:ddara/core/exception/cycle_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/follower/util/follower_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowerNotifier extends AutoDisposeNotifier<FollowerState> {
  @override
  FollowerState build() {
    return const FollowerState();
  }

  /// 에러 토스트를 띄운 뒤 호출해, 같은 에러가 다시 노출되지 않게 비운다.
  void clearError() {
    state = state.copyWith(errorMessage: '');
  }

  /// 촬영본을 presigned URL로 S3에 올리고 따라찍기 사진을 등록한다.
  /// 성공 시 [FollowerState.uploadedCycleId] 에 사이클 id 를 담는다.
  Future<void> upload(int cycleId, String path) async {
    // 이미 전송 중이면 무시한다. (중복 전송 방지)
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: '');
    final useCase = ref.read(followerUploadUseCase);

    try {
      final result = await useCase(cycleId, path);

      state = state.copyWith(
        isLoading: false,
        uploadedCycleId: result.cycleId,
      );
    } on StarterImageUploadException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '이미지 업로드에 실패했습니다.',
      );
    } on NotGroupMemberException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '모임 멤버가 아닙니다.',
      );
    } on CycleNotFoundException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '존재하지 않는 회차입니다.',
      );
    } on NetworkException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '네트워크 연결이 불안정합니다.',
      );
    }
  }
}
