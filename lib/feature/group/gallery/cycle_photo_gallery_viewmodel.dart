import 'package:ddara/core/exception/block_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/domain/model/group/cycle_gallery.dart';
import 'package:ddara/domain/model/group/group_action_error.dart';
import 'package:ddara/domain/model/profile/profile.dart';
import 'package:ddara/domain/model/report/report_reason.dart';
import 'package:ddara/core/util/auto_dispose_guard.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/gallery/util/cycle_photo_gallery_state.dart';
import 'package:ddara/feature/home/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CyclePhotoGalleryViewModel
    extends AutoDisposeFamilyNotifier<CyclePhotoGalleryState, int>
    with AutoDisposeGuard<CyclePhotoGalleryState> {
  @override
  CyclePhotoGalleryState build(int cycleId) {
    watchDispose();
    // 진입 시 cycleId 로 갤러리를 조회한다. (build 는 동기라 fire-and-forget)
    _loadGallery(cycleId);

    return const CyclePhotoGalleryLoading();
  }

  /// 사이클 갤러리(모임 이름·멤버별 사진)와 내 프로필을 조회해 state 에 담는다.
  /// (내 id 로 멤버의 userId 를 비교해 본인 카드를 판별한다)
  Future<void> _loadGallery(int cycleId) async {
    final getCycleGalleryUseCase = ref.read(getCycleGalleryUseCaseProvider);
    final getProfileUseCase = ref.read(getProfileUseCaseProvider);

    try {
      // 갤러리와 내 프로필, 차단 목록을 함께(병렬) 조회한다.
      // (group_page_viewmodel 과 같은 방식 — records 의 `.wait` 는 실패를
      //  ParallelWaitError 로 감싸 아래 개별 예외 분기를 탈 수 없다)
      final results = await Future.wait([
        getCycleGalleryUseCase(cycleId),
        getProfileUseCase(),
        ref.read(getBlockedUserIdsUseCaseProvider)(),
      ]);
      // 화면을 벗어난 뒤 도착한 결과는 버린다.
      if (isDisposed) return;
      // readShotIds 는 인계하지 않는다 — 그 사이 새 댓글이 달렸을 수 있어
      // 방금 받은 서버 값이 항상 더 정확하다.
      state = CyclePhotoGalleryLoaded(
        gallery: results[0] as CycleGallery,
        myUserId: (results[1] as Profile).id,
        blockedUserIds: results[2] as Set<int>,
      );
    } on NotGroupMemberException {
      _fail(GroupActionError.notGroupMember);
    } on GroupNotFoundException {
      _fail(GroupActionError.cycleNotFound);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _fail(GroupActionError.galleryLoadFailed);
    }
  }

  /// 실패를 상태에 반영하고 false 를 돌려준다.
  /// (화면을 벗어난 뒤 도착한 실패는 반영하지 않는다)
  ///
  /// 이미 갤러리가 떠 있으면(액션·재조회 실패) 보던 화면을 유지한 채 토스트로만
  /// 알리고, 최초 조회였다면 본문을 에러 화면으로 바꾼다.
  bool _fail(GroupActionError error) {
    if (isDisposed) return false;
    final current = state;
    state = current is CyclePhotoGalleryLoaded
        ? current.copyWith(isBusy: false, actionError: error)
        : CyclePhotoGalleryLoadError(error);

    return false;
  }

  /// 액션 에러를 소비한 뒤(토스트로 노출 후) 다시 비운다.
  /// 같은 에러가 이후 상태 변경 때 재노출되는 것을 막는다.
  void clearActionError() {
    final current = state;
    if (current is! CyclePhotoGalleryLoaded || current.actionError == null) {
      return;
    }
    state = current.copyWith(clearActionError: true);
  }

  /// 신고·차단의 진입 가드. 갤러리가 없거나 이미 처리 중이면 null 을 돌려
  /// 중복 실행을 막고, 시작할 수 있으면 처리 중으로 세운 상태를 돌려준다.
  CyclePhotoGalleryLoaded? _startAction() {
    final current = state;
    if (current is! CyclePhotoGalleryLoaded || current.isBusy) return null;
    final next = current.copyWith(isBusy: true);
    state = next;

    return next;
  }

  /// [shotId] 사진을 신고한다. 성공하면 검토 상태가 반영되도록 갤러리를
  /// 다시 조회하고 true, 실패하면 actionError 를 채우고 false 를 반환한다.
  Future<bool> reportShot({
    required int shotId,
    required ReportReason reason,
    String? reasonText,
  }) async {
    if (_startAction() == null) return false;
    final reportShotUseCase = ref.read(reportShotUseCaseProvider);

    try {
      await reportShotUseCase(
        shotId: shotId,
        reason: reason,
        reasonText: reasonText,
      );
      // 신고된 사진이 검토 상태로 반영되도록 갤러리를 다시 조회한다.
      // (isBusy 는 _loadGallery 가 내린다)
      await _loadGallery(arg);
      return true;
    } on InvalidReportInputException {
      return _fail(GroupActionError.reportInvalidInput);
    } on ShotNotFoundException {
      return _fail(GroupActionError.reportShotNotFound);
    } on NotGroupMemberException {
      return _fail(GroupActionError.notGroupMember);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      return _fail(GroupActionError.reportFailed);
    }
  }

  /// [userId] 멤버를 차단한다. 성공하면 true, 실패하면 actionError 를 채우고
  /// false 를 반환한다. 요청 시작~완료까지 isBusy 를 true 로 두고, 성공 시
  /// 차단이 반영된(사진 가림) 갤러리를 다시 조회한다.
  Future<bool> blockMember(int userId) async {
    // 차단 API 가 모임 맥락(groupId)을 요구한다. 갤러리가 로드되기 전에는
    // 차단 진입점(멤버 카드)이 없으므로 사실상 도달하지 않는다.
    final started = _startAction();
    if (started == null) return false;

    final blockUserUseCase = ref.read(blockUserUseCaseProvider);

    try {
      await blockUserUseCase(userId, groupId: started.gallery.groupId);
      // 차단 결과를 반영하기 위해 갤러리를 다시 조회한다.
      // (isBusy 는 _loadGallery 가 내린다)
      await _loadGallery(arg);
      // 홈(그룹 썸네일·피드 필터)에도 차단이 반영되도록 재조회시킨다.
      // (홈이 스택에 남아 있으면 즉시, 없으면 다음 진입 때 반영)
      ref.invalidate(homeViewModelProvider);
      return true;
    } on InvalidBlockInputException {
      return _fail(GroupActionError.blockSelf);
    } on BlockTargetNotFoundException {
      return _fail(GroupActionError.blockTargetNotFound);
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      return _fail(GroupActionError.blockFailed);
    }
  }
}
