import 'package:ddara/core/exception/comment_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/core/model/comment/comment.dart';
import 'package:ddara/core/model/report/comment_report_reason.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 사진 댓글 CRUD 공통 동작. (홈 피드 · 사이클 갤러리 notifier 가 공유)
///
/// UseCase 호출과 예외 → 사용자 안내 문구 매핑을 한곳에 모은다. 상태 모양이
/// 서로 다른 notifier 들이 함께 쓰도록, 실패 문구 반영은 [onCommentError]
/// 훅으로, 변경 성공 후처리(피드 재조회 등)는 [afterCommentMutation] 훅으로
/// 위임한다.
mixin CommentActions<S> {
  /// UseCase 조회용 ref. (autoDispose Notifier 가 이미 제공하므로 별도 구현이
  /// 필요 없다 — Notifier 의 ref 와 시그니처를 맞추기 위해 상태 타입 [S] 를 받는다)
  ///
  /// riverpod 2.x 의 Notifier.ref 가 이 타입이라 그대로 따른다.
  /// (riverpod 3 승급 시 `Ref` 로 교체)
  // ignore: deprecated_member_use
  AutoDisposeNotifierProviderRef<S> get ref;

  /// 실패 안내 문구를 상태에 반영한다. (토스트 노출은 화면의 listen 이 담당)
  void onCommentError(String message);

  /// 등록·삭제·신고 성공 직후 후처리. (예: 댓글 수 반영을 위한 피드 재조회)
  /// 필요 없는 화면은 그대로 두면 된다. (기본 no-op)
  Future<void> afterCommentMutation() async {}

  /// [shotId] 사진의 댓글 목록을 조회한다. 성공하면 ([blockedUserIds] 유저의
  /// 댓글을 제외한) 목록을, 실패하면 안내 문구를 반영하고 null 을 반환한다.
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
      onCommentError('이미 삭제된 사진이에요.');
      return null;
    } on NotGroupMemberException {
      onCommentError('해당 모임의 멤버가 아니에요.');
      return null;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      onCommentError('댓글을 불러오지 못했어요.');
      return null;
    }
  }

  /// [shotId] 사진에 댓글을 등록한다. 성공하면 생성된 댓글을, 실패하면
  /// 안내 문구를 반영하고 null 을 반환한다.
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
      onCommentError('댓글 내용을 확인해 주세요.');
      return null;
    } on ShotLockedException {
      onCommentError('내 인증샷을 올려야 댓글을 달 수 있어요.');
      return null;
    } on ShotUnderReviewException {
      onCommentError('검토 중인 사진에는 댓글을 달 수 없어요.');
      return null;
    } on ShotNotFoundException {
      onCommentError('이미 삭제된 사진이에요.');
      return null;
    } on NotGroupMemberException {
      onCommentError('해당 모임의 멤버가 아니에요.');
      return null;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      onCommentError('댓글을 등록하지 못했어요.');
      return null;
    }
  }

  /// [commentId] 댓글을 삭제한다. 성공하면 true, 실패하면 안내 문구를
  /// 반영하고 false 를 반환한다.
  Future<bool> deleteComment({required int commentId}) async {
    final deleteCommentUseCase = ref.read(deleteCommentUseCaseProvider);

    try {
      await deleteCommentUseCase(commentId);
      await afterCommentMutation();
      return true;
    } on CommentForbiddenException {
      onCommentError('내가 작성한 댓글만 삭제할 수 있어요.');
      return false;
    } on CommentNotFoundException {
      onCommentError('이미 삭제된 댓글이에요.');
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      onCommentError('댓글을 삭제하지 못했어요.');
      return false;
    }
  }

  /// [commentId] 댓글을 [content] 로 수정한다. 성공하면 수정된 내용을,
  /// 실패하면 안내 문구를 반영하고 null 을 반환한다.
  /// (수정은 목록에 이미 반영되므로 후처리를 부르지 않는다)
  Future<String?> editComment({
    required int commentId,
    required String content,
  }) async {
    final editCommentUseCase = ref.read(editCommentUseCaseProvider);

    try {
      return await editCommentUseCase(commentId: commentId, content: content);
    } on InvalidCommentInputException {
      onCommentError('댓글 내용을 확인해 주세요.');
      return null;
    } on CommentForbiddenException {
      onCommentError('내가 작성한 댓글만 수정할 수 있어요.');
      return null;
    } on CommentNotFoundException {
      onCommentError('이미 삭제된 댓글이에요.');
      return null;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      onCommentError('댓글을 수정하지 못했어요.');
      return null;
    }
  }

  /// [commentId] 댓글을 신고한다. 성공하면 true, 실패하면 안내 문구를
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
      onCommentError('신고 내용이 올바르지 않아요.');
      return false;
    } on ShotNotFoundException {
      onCommentError('이미 삭제된 댓글이에요.');
      return false;
    } on NotGroupMemberException {
      onCommentError('해당 모임의 멤버가 아니에요.');
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      onCommentError('신고하지 못했어요.');
      return false;
    }
  }
}
