import 'package:ddara/core/comment/comment_action_error.dart';
import 'package:ddara/core/comment/comment_actions.dart';
import 'package:ddara/core/exception/block_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/core/model/comment/comment.dart';
import 'package:ddara/core/model/report/report_reason.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/group/gallery/util/cycle_photo_gallery_state.dart';
import 'package:ddara/feature/home/provider/notifier_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CyclePhotoGalleryNotifier
    extends AutoDisposeFamilyNotifier<CyclePhotoGalleryState, int>
    with CommentActions<CyclePhotoGalleryState> {
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

  /// 에러 메시지를 소비한 뒤(토스트로 노출 후) 다시 비운다.
  /// 같은 에러가 이후 상태 변경 때 재노출되는 것을 막는다.
  void clearError() {
    if (state.errorMessage.isEmpty) return;
    state = state.copyWith(errorMessage: '');
  }

  /// [shotId] 사진을 신고한다. 성공하면 검토 상태가 반영되도록 갤러리를
  /// 다시 조회하고 true, 실패하면 errorMessage 를 채우고 false 를 반환한다.
  Future<bool> reportShot({
    required int shotId,
    required ReportReason reason,
    String? reasonText,
  }) async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true);
    final reportShotUseCase = ref.read(reportShotUseCaseProvider);

    try {
      await reportShotUseCase(
        shotId: shotId,
        reason: reason,
        reasonText: reasonText,
      );
      // 신고된 사진이 검토 상태로 반영되도록 갤러리를 다시 조회한다.
      // (isLoading 은 _loadGallery 가 내린다)
      await _loadGallery(arg);
      return true;
    } on InvalidReportInputException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '신고 내용이 올바르지 않아요.',
      );
      return false;
    } on ShotNotFoundException {
      state = state.copyWith(isLoading: false, errorMessage: '이미 삭제된 사진이에요.');
      return false;
    } on NotGroupMemberException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '해당 모임의 멤버가 아니에요.',
      );
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(isLoading: false, errorMessage: '신고하지 못했어요.');
      return false;
    }
  }

  /// [userId] 멤버를 차단한다. 성공하면 true, 실패하면 errorMessage 를 채우고
  /// false 를 반환한다. 요청 시작~완료까지 isLoading 을 true 로 두고, 성공 시
  /// 차단이 반영된(사진 가림) 갤러리를 다시 조회한다.
  Future<bool> blockMember(int userId) async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true);
    final blockUserUseCase = ref.read(blockUserUseCaseProvider);

    try {
      await blockUserUseCase(userId);
      // 차단 결과를 반영하기 위해 갤러리를 다시 조회한다.
      // (isLoading 은 _loadGallery 가 내린다)
      await _loadGallery(arg);
      // 홈(그룹 썸네일·피드 필터)에도 차단이 반영되도록 재조회시킨다.
      // (홈이 스택에 남아 있으면 즉시, 없으면 다음 진입 때 반영)
      ref.invalidate(homeNotifierProvider);
      return true;
    } on InvalidBlockInputException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '자기 자신은 차단할 수 없어요.',
      );
      return false;
    } on BlockTargetNotFoundException {
      state = state.copyWith(isLoading: false, errorMessage: '존재하지 않는 사용자예요.');
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(isLoading: false, errorMessage: '차단하지 못했어요.');
      return false;
    }
  }

  @override
  void onCommentError(CommentActionError error) {
    state = state.copyWith(commentError: error);
  }

  /// 댓글 액션 에러를 소비한 뒤(토스트로 노출 후) 다시 비운다.
  void clearCommentError() {
    if (state.commentError == null) return;
    state = state.copyWith(clearCommentError: true);
  }

  // 갤러리는 댓글이 화면에 노출되지 않으므로 변경 성공 후 재조회하지 않는다.
  // (afterCommentMutation 은 기본 no-op 유지)

  /// [shotId] 사진의 댓글 목록을 조회한다. 뷰어가 열린 동안 차단이 늘 수
  /// 있어, 호출 시점의 최신 차단 목록(state)으로 필터링한다.
  @override
  Future<List<Comment>?> loadComments({
    required int shotId,
    Set<int> blockedUserIds = const {},
  }) {
    return super.loadComments(
      shotId: shotId,
      blockedUserIds: state.blockedUserIds,
    );
  }
}
