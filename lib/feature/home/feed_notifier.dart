import 'package:ddara/core/exception/comment_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/core/model/comment/comment.dart';
import 'package:ddara/core/model/report/comment_report_reason.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/home/util/feed_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedNotifier extends AutoDisposeNotifier<FeedState> {
  /// autoDispose 폐기 후 in-flight 응답이 state 를 만지지 않도록 하는 가드.
  /// (홈 진입 직후 로그아웃 등으로 폐기된 뒤 응답이 도착하면 StateError)
  bool _disposed = false;

  @override
  FeedState build() {
    _disposed = false; // invalidate 재빌드(같은 인스턴스) 대비 리셋.
    ref.onDispose(() => _disposed = true);
    _load();
    return const FeedState(isLoading: true);
  }

  /// 폐기 이후 도착한 응답을 무시하고 상태를 갱신한다.
  void _update(FeedState Function(FeedState state) updater) {
    if (_disposed) return;
    state = updater(state);
  }

  /// 최근 업데이트 피드와 내 프로필을 조회해 state 에 담는다.
  /// (내 id·닉네임은 댓글 시트에서 내 댓글을 구분·표기하는 데 쓴다)
  Future<void> _load() async {
    final getFeedUseCase = ref.read(getFeedUseCaseProvider);

    try {
      // size 는 생략해 서버 기본값(최신 30개)을 따른다.
      final feed = await getFeedUseCase();
      final profile = await _loadProfile();
      _update(
        (s) => s.copyWith(
          isLoading: false,
          feed: feed,
          myUserId: profile?.$1,
          myNickname: profile?.$2 ?? '',
          myProfileImageUrl: profile?.$3,
          // 이전 실패 흔적을 지운다. (에러 → 새로고침 성공 직후
          // 이전 메시지가 토스트로 재노출되는 것을 방지)
          errorMessage: '',
        ),
      );
    } catch (_) {
      _update(
        (s) => s.copyWith(
          isLoading: false,
          errorMessage: '최근 업데이트를 불러오지 못했어요.',
        ),
      );
    }
  }

  /// 내 (userId, 닉네임, 프로필 이미지 URL). 프로필 조회가 실패해도 피드는
  /// 보여줘야 하므로 실패 시 null 로 대체한다.
  /// (내 댓글 구분이 한 번 빠질 뿐 치명적이지 않다)
  Future<(int, String, String?)?> _loadProfile() async {
    try {
      final profile = await ref.read(getProfileUseCaseProvider)();
      return (profile.id, profile.name, profile.profileImageUrl);
    } catch (_) {
      return null;
    }
  }

  /// 피드를 다시 조회한다. (당겨서 새로고침)
  ///
  /// 피드가 이미 로드된 상태에서 실패하면 errorMessage 가 채워져 화면의
  /// listen 이 토스트로 안내하고, 보던 피드는 유지된다.
  Future<void> refresh() => _load();

  /// 에러 메시지를 소비한 뒤(토스트로 노출 후) 다시 비운다.
  /// 같은 에러가 이후 상태 변경 때 재노출되는 것을 막는다.
  void clearError() {
    if (state.errorMessage.isEmpty) return;
    _update((s) => s.copyWith(errorMessage: ''));
  }

  /// [shotId] 사진의 댓글 목록을 조회한다. 성공하면 ([blockedUserIds] 유저의
  /// 댓글을 제외한) 목록을, 실패하면 errorMessage 를 채우고 null 을 반환한다.
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
      _update((s) => s.copyWith(errorMessage: '이미 삭제된 사진이에요.'));
      return null;
    } on NotGroupMemberException {
      _update((s) => s.copyWith(errorMessage: '해당 모임의 멤버가 아니에요.'));
      return null;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _update((s) => s.copyWith(errorMessage: '댓글을 불러오지 못했어요.'));
      return null;
    }
  }

  /// [shotId] 사진에 댓글을 등록한다. 성공하면 생성된 댓글을, 실패하면
  /// errorMessage 를 채우고 null 을 반환한다.
  ///
  /// 등록에 성공하면 피드의 댓글 수가 달라지므로 피드를 다시 조회한다.
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
      // 댓글 수·미리보기가 반영되도록 피드를 다시 조회한다. (실패해도 등록은
      // 성공했으므로 결과는 그대로 돌려준다)
      await _refreshFeed();
      return created;
    } on InvalidCommentInputException {
      _update((s) => s.copyWith(errorMessage: '댓글 내용을 확인해 주세요.'));
      return null;
    } on ShotLockedException {
      _update((s) => s.copyWith(errorMessage: '내 인증샷을 올려야 댓글을 달 수 있어요.'));
      return null;
    } on ShotUnderReviewException {
      _update((s) => s.copyWith(errorMessage: '검토 중인 사진에는 댓글을 달 수 없어요.'));
      return null;
    } on ShotNotFoundException {
      _update((s) => s.copyWith(errorMessage: '이미 삭제된 사진이에요.'));
      return null;
    } on NotGroupMemberException {
      _update((s) => s.copyWith(errorMessage: '해당 모임의 멤버가 아니에요.'));
      return null;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _update((s) => s.copyWith(errorMessage: '댓글을 등록하지 못했어요.'));
      return null;
    }
  }

  /// [commentId] 댓글을 삭제한다. 성공하면 true, 실패하면 errorMessage 를
  /// 채우고 false 를 반환한다.
  Future<bool> deleteComment({required int commentId}) async {
    final deleteCommentUseCase = ref.read(deleteCommentUseCaseProvider);

    try {
      await deleteCommentUseCase(commentId);
      // 댓글 수·미리보기가 반영되도록 피드를 다시 조회한다.
      await _refreshFeed();
      return true;
    } on CommentForbiddenException {
      _update((s) => s.copyWith(errorMessage: '내가 작성한 댓글만 삭제할 수 있어요.'));
      return false;
    } on CommentNotFoundException {
      _update((s) => s.copyWith(errorMessage: '이미 삭제된 댓글이에요.'));
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _update((s) => s.copyWith(errorMessage: '댓글을 삭제하지 못했어요.'));
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
      _update((s) => s.copyWith(errorMessage: '댓글 내용을 확인해 주세요.'));
      return null;
    } on CommentForbiddenException {
      _update((s) => s.copyWith(errorMessage: '내가 작성한 댓글만 수정할 수 있어요.'));
      return null;
    } on CommentNotFoundException {
      _update((s) => s.copyWith(errorMessage: '이미 삭제된 댓글이에요.'));
      return null;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _update((s) => s.copyWith(errorMessage: '댓글을 수정하지 못했어요.'));
      return null;
    }
  }

  /// [commentId] 댓글을 신고한다. 성공하면 true, 실패하면 errorMessage 를
  /// 채우고 false 를 반환한다.
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
      // 신고한(reportedByMe) 댓글이 카드 미리보기에서도 걸러지도록 피드를
      // 다시 조회한다. (실패해도 접수는 성공했으므로 결과는 그대로 돌려준다)
      await _refreshFeed();
      return true;
    } on InvalidReportInputException {
      _update((s) => s.copyWith(errorMessage: '신고 내용이 올바르지 않아요.'));
      return false;
    } on ShotNotFoundException {
      _update((s) => s.copyWith(errorMessage: '이미 삭제된 댓글이에요.'));
      return false;
    } on NotGroupMemberException {
      _update((s) => s.copyWith(errorMessage: '해당 모임의 멤버가 아니에요.'));
      return false;
    } catch (_) {
      // NetworkException 및 기타 예기치 못한 오류.
      _update((s) => s.copyWith(errorMessage: '신고하지 못했어요.'));
      return false;
    }
  }

  /// 피드만 조용히 다시 조회한다. (댓글 수·미리보기 갱신용)
  ///
  /// 실패해도 이미 보이는 피드를 지우거나 에러를 띄우지 않는다. 유발한 동작
  /// (댓글 등록·삭제·신고)은 이미 성공했고, 반영이 한 박자 늦을 뿐이다.
  Future<void> _refreshFeed() async {
    try {
      final feed = await ref.read(getFeedUseCaseProvider)();
      _update((s) => s.copyWith(feed: feed));
    } catch (_) {
      // 무시. (다음 진입 때 갱신된다)
    }
  }
}
