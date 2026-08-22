import 'package:ddara/core/exception/cycle_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/domain/model/group/group_action_error.dart';
import 'package:ddara/core/local/provider/local_provider.dart';
import 'package:ddara/core/local/storage_key.dart';
import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/follower/util/follower_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 가이드 투어 시청 여부를 남기는 저장소 키.
///
/// 현재 Camera 는 투어 종류를 구분하지 않는 단일 플래그를 쓰므로, 진입
/// 안내인 코너 미니뷰 키 하나로 둘 다 갈음한다.
const String _tourSeenKey = StorageKey.cameraCornerTourDone;

class FollowerViewModel extends AutoDisposeNotifier<FollowerState>
    with AutoDisposeGuard<FollowerState> {
  @override
  FollowerState build() {
    watchDispose();

    return const FollowerState();
  }

  /// 에러 토스트를 띄운 뒤 호출해, 같은 에러가 다시 노출되지 않게 비운다.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// 가이드 투어를 이미 봤는지 저장소(SharedPreferences)에서 확인한다.
  ///
  /// 서버 조회(GET /api/users/me/camera-guide)로 옮기기 전까지의 임시 구현이라
  /// 기기에만 남는다. → 앱을 지우거나 다른 기기로 옮기면 안내가 다시 뜬다.
  void loadTourSeen() {
    final seen =
        ref.read(sharedPreferencesProvider).getBool(_tourSeenKey) ?? false;
    if (isDisposed) return;
    state = state.copyWith(isTourSeen: seen);
  }

  /// 투어를 끝까지 본 것으로 표시한다. → 다음부터는 자동으로 뜨지 않는다.
  /// (AppBar 의 도움말 버튼으로는 언제든 다시 볼 수 있다)
  Future<void> completeTour() async {
    if (state.isTourSeen ?? false) return;

    // 저장 전에 읽어둔다. 저장을 기다리는 사이 화면을 벗어나면 ref 를 더 쓸 수
    // 없기 때문이다.
    final prefs = ref.read(sharedPreferencesProvider);
    state = state.copyWith(isTourSeen: true);
    await prefs.setBool(_tourSeenKey, true);
  }

  /// 업로드 실패를 상태에 반영하고 로딩을 내린다.
  /// (업로드 중 화면을 벗어났으면 반영하지 않는다)
  void _fail(GroupActionError error) {
    if (isDisposed) return;
    state = state.copyWith(isLoading: false, error: error);
  }

  /// 촬영본을 presigned URL로 S3에 올리고 따라찍기 사진을 등록한다.
  /// 성공하면 사진이 등록된 사이클 id 를, 실패하면 null 을 반환한다.
  /// (실패 사유는 [FollowerState.error] 로 내려 화면이 토스트로 안내한다)
  ///
  /// 성공 후 이동은 일회성 이벤트라 상태에 남기지 않고 반환값으로 넘긴다 —
  /// 호출부가 결과를 받아 직접 화면을 전환한다.
  Future<int?> upload(int cycleId, String path) async {
    // 이미 전송 중이면 무시한다. (중복 전송 방지)
    if (state.isLoading) return null;

    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = ref.read(followerUploadUseCase);

    try {
      final result = await useCase(cycleId, path);

      // 업로드 중 화면을 벗어났으면 상태만 건드리지 않고 결과는 그대로 넘긴다.
      // (호출부가 mounted 를 확인해 이동 여부를 정한다)
      if (!isDisposed) state = state.copyWith(isLoading: false);

      return result.cycleId;
    } on StarterImageUploadException {
      _fail(GroupActionError.imageUploadFailed);
    } on NotGroupMemberException {
      _fail(GroupActionError.notGroupMember);
    } on CycleNotFoundException {
      _fail(GroupActionError.cycleNotFound);
    } on NetworkException {
      _fail(GroupActionError.network);
    } catch (_) {
      // 위에 나열되지 않은 오류(파일 IO 실패·매퍼 캐스트 오류 등).
      // 여기서 잡지 않으면 isLoading 이 true 로 남아 로딩 오버레이가 화면을
      // 계속 덮은 채 아무것도 할 수 없게 된다.
      _fail(GroupActionError.followerUploadFailed);
    }
    return null;
  }
}
