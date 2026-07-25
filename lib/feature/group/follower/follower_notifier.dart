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
  /// 성공하면 사진이 등록된 사이클 id 를, 실패하면 null 을 반환한다.
  /// (실패 사유는 [FollowerState.errorMessage] 로 내려 화면이 토스트로 안내한다)
  ///
  /// 성공 후 이동은 일회성 이벤트라 상태에 남기지 않고 반환값으로 넘긴다 —
  /// 호출부가 결과를 받아 직접 화면을 전환한다.
  Future<int?> upload(int cycleId, String path) async {
    // 이미 전송 중이면 무시한다. (중복 전송 방지)
    if (state.isLoading) return null;

    state = state.copyWith(isLoading: true, errorMessage: '');
    final useCase = ref.read(followerUploadUseCase);

    try {
      final result = await useCase(cycleId, path);

      state = state.copyWith(isLoading: false);
      return result.cycleId;
    } on StarterImageUploadException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '이미지 업로드에 실패했습니다.',
      );
    } on NotGroupMemberException {
      state = state.copyWith(isLoading: false, errorMessage: '모임 멤버가 아닙니다.');
    } on CycleNotFoundException {
      state = state.copyWith(isLoading: false, errorMessage: '존재하지 않는 회차입니다.');
    } on NetworkException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '네트워크 연결이 불안정합니다.',
      );
    } catch (_) {
      // 위에 나열되지 않은 오류(파일 IO 실패·매퍼 캐스트 오류 등).
      // 여기서 잡지 않으면 isLoading 이 true 로 남아 로딩 오버레이가 화면을
      // 계속 덮은 채 아무것도 할 수 없게 된다.
      state = state.copyWith(isLoading: false, errorMessage: '사진을 올리지 못했어요.');
    }
    return null;
  }
}
