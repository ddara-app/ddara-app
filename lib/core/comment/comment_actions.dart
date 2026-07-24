import 'package:ddara/core/comment/comment_action_error.dart';
import 'package:ddara/core/exception/comment_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/core/model/comment/comment.dart';
import 'package:ddara/core/model/report/comment_report_reason.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 사진 댓글 CRUD 공통 동작. (홈 피드 · 사이클 갤러리 notifier 가 공유)
///
/// UseCase 호출과 예외 → 실패 종류([CommentActionError]) 매핑을 한곳에
/// 모은다. 상태 모양이 서로 다른 notifier 들이 함께 쓰도록, 실패 반영은
/// [onCommentError] 훅으로, 변경 성공 후처리(피드 재조회 등)는
/// [afterCommentMutation] 훅으로 위임한다. 사용자 문구는 화면에서 l10n 으로
/// 매핑한다. (CommentActionErrorMessage.message)
mixin CommentActions<S> {
  /// UseCase 조회용 ref. (autoDispose Notifier 가 이미 제공하므로 별도 구현이
  /// 필요 없다 — Notifier 의 ref 와 시그니처를 맞추기 위해 상태 타입 [S] 를 받는다)
  ///
  /// riverpod 2.x 의 Notifier.ref 가 이 타입이라 그대로 따른다.
  /// (riverpod 3 승급 시 `Ref` 로 교체)
  // ignore: deprecated_member_use
  AutoDisposeNotifierProviderRef<S> get ref;

  /// 실패 종류를 상태에 반영한다. (토스트 노출은 화면의 listen 이 담당)
  void onCommentError(CommentActionError error);

  /// 등록·삭제·신고 성공 직후 후처리. (예: 댓글 수 반영을 위한 피드 재조회)
  /// 필요 없는 화면은 그대로 두면 된다. (기본 no-op)
  Future<void> afterCommentMutation() async {}

  /// [shotId] 사진의 댓글 목록을 조회한다. 성공하면 ([blockedUserIds] 유저의
  /// 댓글을 제외한) 목록을, 실패하면 실패 종류를 반영하고 null 을 반환한다.
  Future<List<Comment>?> loadComments({
    required int shotId,
    Set<int> blockedUserIds = const {},
  }) async {
    final getCommentsUseCase = ref.read(getCommentsUseCaseProvider);

    try {
      final comments = await getCommentsUseCase(shotId);
      // 차단한 유저의 댓글은 보이지 않게 제외한다.
      return comments
          .where((comment) => !blockedUserIds.contains(comment.userId))
          .toList();
    } on ShotNotFoundException {
      onCommentError(CommentActionError.photoDeleted);
      return null;
    } on NotGroupMemberException {
      onCommentError(CommentActionError.notGroupMember);
      return null;
    } catch (e) {
      // NetworkException 및 기타 예기치 못한 오류.
      debugPrint('[Comment] 목록 조회 실패: $e');
      onCommentError(CommentActionError.loadFailed);
      return null;
    }
  }

  /// [shotId] 사진에 댓글을 등록한다. 성공하면 생성된 댓글을, 실패하면
  /// 실패 종류를 반영하고 null 을 반환한다.
  Future<Comment?> submitComment({
    required int shotId,
    required String content,
  }) async {
    final createCommentUseCase = ref.read(createCommentUseCaseProvider);

    try {
      final created = await createCommentUseCase(
        shotId: shotId,
        content: content,
      );
      // 후처리(피드 재조회 등)가 실패해도 등록은 성공했으므로 결과는 그대로
      // 돌려준다.
      await afterCommentMutation();
      return created;
    } on InvalidCommentInputException {
      onCommentError(CommentActionError.invalidInput);
      return null;
    } on ShotLockedException {
      onCommentError(CommentActionError.photoLocked);
      return null;
    } on ShotUnderReviewException {
      onCommentError(CommentActionError.photoUnderReview);
      return null;
    } on ShotNotFoundException {
      onCommentError(CommentActionError.photoDeleted);
      return null;
    } on NotGroupMemberException {
      onCommentError(CommentActionError.notGroupMember);
      return null;
    } catch (e) {
      // NetworkException 및 기타 예기치 못한 오류.
      debugPrint('[Comment] 등록 실패: $e');
      onCommentError(CommentActionError.submitFailed);
      return null;
    }
  }

  /// [commentId] 댓글을 삭제한다. 성공하면 true, 실패하면 실패 종류를
  /// 반영하고 false 를 반환한다.
  Future<bool> deleteComment({required int commentId}) async {
    final deleteCommentUseCase = ref.read(deleteCommentUseCaseProvider);

    try {
      await deleteCommentUseCase(commentId);
      await afterCommentMutation();
      return true;
    } on CommentForbiddenException {
      onCommentError(CommentActionError.deleteForbidden);
      return false;
    } on CommentNotFoundException {
      onCommentError(CommentActionError.commentAlreadyDeleted);
      return false;
    } catch (e) {
      // NetworkException 및 기타 예기치 못한 오류.
      debugPrint('[Comment] 삭제 실패: $e');
      onCommentError(CommentActionError.deleteFailed);
      return false;
    }
  }

  /// [commentId] 댓글을 [content] 로 수정한다. 성공하면 수정된 내용을,
  /// 실패하면 실패 종류를 반영하고 null 을 반환한다.
  /// (수정은 목록에 이미 반영되므로 후처리를 부르지 않는다)
  Future<String?> editComment({
    required int commentId,
    required String content,
  }) async {
    final editCommentUseCase = ref.read(editCommentUseCaseProvider);

    try {
      return await editCommentUseCase(commentId: commentId, content: content);
    } on InvalidCommentInputException {
      onCommentError(CommentActionError.invalidInput);
      return null;
    } on CommentForbiddenException {
      onCommentError(CommentActionError.editForbidden);
      return null;
    } on CommentNotFoundException {
      onCommentError(CommentActionError.commentAlreadyDeleted);
      return null;
    } catch (e) {
      // NetworkException 및 기타 예기치 못한 오류.
      debugPrint('[Comment] 수정 실패: $e');
      onCommentError(CommentActionError.editFailed);
      return null;
    }
  }

  /// [commentId] 댓글을 신고한다. 성공하면 true, 실패하면 실패 종류를
  /// 반영하고 false 를 반환한다.
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
      // 신고한(reportedByMe) 댓글이 목록·미리보기에서 걸러지도록 후처리를
      // 부른다. (실패해도 접수는 성공했으므로 결과는 그대로 돌려준다)
      await afterCommentMutation();
      return true;
    } on InvalidReportInputException {
      onCommentError(CommentActionError.invalidReport);
      return false;
    } on ShotNotFoundException {
      onCommentError(CommentActionError.commentAlreadyDeleted);
      return false;
    } on NotGroupMemberException {
      onCommentError(CommentActionError.notGroupMember);
      return false;
    } catch (e) {
      // NetworkException 및 기타 예기치 못한 오류.
      debugPrint('[Comment] 신고 실패: $e');
      onCommentError(CommentActionError.reportFailed);
      return false;
    }
  }
}
