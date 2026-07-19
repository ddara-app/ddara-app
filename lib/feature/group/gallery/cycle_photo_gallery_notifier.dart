import 'package:ddara/core/exception/comment_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/core/model/comment/comment.dart';
import 'package:ddara/core/model/report/comment_report_reason.dart';
import 'package:ddara/core/model/report/report_reason.dart';
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

  /// [shotId] 사진의 댓글 목록을 조회한다. 성공하면 (차단 유저 댓글을 제외한)
  /// 목록을, 실패하면 errorMessage 를 채우고 null 을 반환한다.
  Future<List<Comment>?> loadComments({required int shotId}) async {
    final getCommentsUseCase = ref.read(getCommentsUseCaseProvider);

    try {
      final comments = await getCommentsUseCase(shotId);
      // 차단한 유저의 댓글은 보이지 않게 제외한다.
      return comments
          .where((comment) => !state.blockedUserIds.contains(comment.userId))
          .toList();
    } on ShotNotFoundException {
      state = state.copyWith(errorMessage: '이미 삭제된 사진이에요.');
      return null;
    } on NotGroupMemberException {
      state = state.copyWith(errorMessage: '해당 모임의 멤버가 아니에요.');
      return null;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(errorMessage: '댓글을 불러오지 못했어요.');
      return null;
    }
  }

  /// [commentId] 댓글을 삭제한다. 성공하면 true, 실패하면 errorMessage 를
  /// 채우고 false 를 반환한다.
  Future<bool> deleteComment({required int commentId}) async {
    final deleteCommentUseCase = ref.read(deleteCommentUseCaseProvider);

    try {
      await deleteCommentUseCase(commentId);
      return true;
    } on CommentForbiddenException {
      state = state.copyWith(errorMessage: '내가 작성한 댓글만 삭제할 수 있어요.');
      return false;
    } on CommentNotFoundException {
      state = state.copyWith(errorMessage: '이미 삭제된 댓글이에요.');
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(errorMessage: '댓글을 삭제하지 못했어요.');
      return false;
    }
  }

  /// [commentId] 댓글을 신고한다. 성공하면 true, 실패하면 errorMessage 를
  /// 채우고 false 를 반환한다. (신고해도 댓글은 그대로 노출 — 재조회하지 않는다)
  Future<bool> reportComment({
    required int commentId,
    required CommentReportReason reason,
    String? reasonText,
  }) async {
    final reportCommentUseCase = ref.read(reportCommentUseCaseProvider);

    try {
      await reportCommentUseCase(
        commentId: commentId,
        reason: reason,
        reasonText: reasonText,
      );
      return true;
    } on InvalidReportInputException {
      state = state.copyWith(errorMessage: '신고 내용이 올바르지 않아요.');
      return false;
    } on ShotNotFoundException {
      state = state.copyWith(errorMessage: '이미 삭제된 댓글이에요.');
      return false;
    } on NotGroupMemberException {
      state = state.copyWith(errorMessage: '해당 모임의 멤버가 아니에요.');
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(errorMessage: '신고하지 못했어요.');
      return false;
    }
  }

  /// [commentId] 댓글을 [content] 로 수정한다. 성공하면 수정된 내용을,
  /// 실패하면 errorMessage 를 채우고 null 을 반환한다.
  Future<String?> editComment({
    required int commentId,
    required String content,
  }) async {
    final editCommentUseCase = ref.read(editCommentUseCaseProvider);

    try {
      return await editCommentUseCase(commentId: commentId, content: content);
    } on InvalidCommentInputException {
      state = state.copyWith(errorMessage: '댓글 내용을 확인해 주세요.');
      return null;
    } on CommentForbiddenException {
      state = state.copyWith(errorMessage: '내가 작성한 댓글만 수정할 수 있어요.');
      return null;
    } on CommentNotFoundException {
      state = state.copyWith(errorMessage: '이미 삭제된 댓글이에요.');
      return null;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(errorMessage: '댓글을 수정하지 못했어요.');
      return null;
    }
  }

  /// [shotId] 사진에 댓글을 등록한다. 성공하면 생성된 댓글을, 실패하면
  /// errorMessage 를 채우고 null 을 반환한다.
  /// (댓글은 갤러리 화면에 노출되지 않으므로 갤러리를 재조회하지 않는다)
  Future<Comment?> submitComment({
    required int shotId,
    required String content,
  }) async {
    final createCommentUseCase = ref.read(createCommentUseCaseProvider);

    try {
      return await createCommentUseCase(shotId: shotId, content: content);
    } on InvalidCommentInputException {
      state = state.copyWith(errorMessage: '댓글 내용을 확인해 주세요.');
      return null;
    } on ShotLockedException {
      state = state.copyWith(errorMessage: '내 인증샷을 올려야 댓글을 달 수 있어요.');
      return null;
    } on ShotUnderReviewException {
      state = state.copyWith(errorMessage: '검토 중인 사진에는 댓글을 달 수 없어요.');
      return null;
    } on ShotNotFoundException {
      state = state.copyWith(errorMessage: '이미 삭제된 사진이에요.');
      return null;
    } on NotGroupMemberException {
      state = state.copyWith(errorMessage: '해당 모임의 멤버가 아니에요.');
      return null;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      state = state.copyWith(errorMessage: '댓글을 등록하지 못했어요.');
      return null;
    }
  }
}
