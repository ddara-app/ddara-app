import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/gallery/util/cycle_photo_gallery_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CyclePhotoGalleryNotifier
    extends AutoDisposeFamilyNotifier<CyclePhotoGalleryState, int> {
  @override
  CyclePhotoGalleryState build(int cycleId) {
    // 진입 시 cycleId 로 갤러리를 조회한다. (build 는 동기라 fire-and-forget)
    _loadGallery(cycleId);

    return const CyclePhotoGalleryState(isLoading: true);
  }

  /// 사이클 갤러리(모임 이름·멤버별 사진)와 내 프로필을 조회해 state 에 담는다.
  /// (내 id 로 멤버의 userId 를 비교해 본인 카드를 판별한다)
  Future<void> _loadGallery(int cycleId) async {
    final getCycleGalleryUseCase = ref.read(getCycleGalleryUseCaseProvider);
    final getProfileUseCase = ref.read(getProfileUseCaseProvider);

    try {
      final gallery = await getCycleGalleryUseCase(cycleId);
      final profile = await getProfileUseCase();
      final blockedUserIds = await _loadBlockedUserIds();
      state = state.copyWith(
        isLoading: false,
        gallery: gallery,
        myUserId: profile.id,
        blockedUserIds: blockedUserIds,
      );
    } on NotGroupMemberException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '해당 모임의 멤버가 아니에요.',
      );
    } on GroupNotFoundException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '존재하지 않는 사이클이에요.',
      );
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(
        isLoading: false,
        errorMessage: '사진을 불러오지 못했어요.',
      );
    }
  }

  /// 내가 차단한 사용자 userId 집합을 조회한다.
  ///
  /// 차단 목록 조회가 실패해도 화면(갤러리)을 막지 않도록, 실패 시 빈 집합으로
  /// 대체한다. (사진 가림이 한 번 빠질 뿐 치명적이지 않다)
  Future<Set<int>> _loadBlockedUserIds() async {
    try {
      final blockedUsers = await ref.read(getBlockedUsersUseCaseProvider)();
      return blockedUsers.users.map((user) => user.userId).toSet();
    } catch (_) {
      return const {};
    }
  }
}
