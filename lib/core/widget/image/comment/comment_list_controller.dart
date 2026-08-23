import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:flutter/foundation.dart';

/// 댓글 목록의 상태와 서버 연동.
///
/// 조회 · 등록(낙관적) · 재전송 · 수정 · 삭제 · 신고 · 차단을 맡고, 목록이
/// 바뀔 때마다 알린다. 입력창 · 스크롤 · 시트 높이는 화면이 들고 있으므로,
/// 화면이 이어서 해야 할 일([onCommentAdded] · [onListReloaded])만 콜백으로
/// 알린다.
///
/// 낙관적 업데이트의 계약은 docs/optimistic_comment_update.md 에 정리돼 있다.
class CommentListController extends ChangeNotifier {
  CommentListController({
    required List<PhotoComment> initialComments,
    required this.onLoadComments,
    required this.onSubmitComment,
    required this.onEditComment,
    required this.onDeleteComment,
    required this.onReportComment,
    required this.onBlockComment,
    this.onCommentAdded,
    this.onListReloaded,
  }) : _comments = [...initialComments];

  /// 댓글 목록 조회 콜백. 성공 시 표시할 목록을, 실패 시 null 을 반환한다.
  final Future<List<PhotoComment>?> Function() onLoadComments;

  /// 댓글 등록 콜백. 성공 시 화면에 추가할 댓글을, 실패 시 null 을 반환한다.
  final Future<PhotoComment?> Function(String content) onSubmitComment;

  /// 내 댓글 수정 콜백. 성공 시 갱신된 댓글을, 실패 시 null 을 반환한다.
  final Future<PhotoComment?> Function(PhotoComment comment, String newContent)
  onEditComment;

  /// 내 댓글 삭제 콜백. 성공하면 true.
  final Future<bool> Function(PhotoComment comment) onDeleteComment;

  /// 상대 댓글 신고 콜백. 사유가 확정되면 true.
  final Future<bool> Function(PhotoComment comment) onReportComment;

  /// 상대 댓글 작성자 차단 콜백. 차단에 성공하면 true.
  final Future<bool> Function(PhotoComment comment) onBlockComment;

  /// 낙관적 댓글이 목록에 붙은 직후. (최신 댓글 쪽으로 이동하는 연출용)
  final VoidCallback? onCommentAdded;

  /// 목록이 서버 목록으로 교체된 직후. (최신 댓글을 먼저 보여주는 연출용)
  final VoidCallback? onListReloaded;

  /// 화면에 표시 중인 댓글 목록. 전달받은 목록으로 시작해, [reload] 로 서버
  /// 목록을 받아 교체하고, 등록·수정·삭제 결과를 반영한다.
  final List<PhotoComment> _comments;

  bool _loading = false;
  int _generation = 0;

  /// 댓글 수정 요청 진행 중 여부. (연속 전송 방지)
  /// 화면에 드러나지 않는 가드라서 갱신할 때 알리지 않는다.
  /// (등록은 낙관적 업데이트라 댓글별 [PhotoComment.sendStatus] 로 가려낸다)
  bool _editSubmitting = false;

  bool _disposed = false;

  /// 오래된 것 → 최신 순서의 댓글 목록.
  List<PhotoComment> get comments => List.unmodifiable(_comments);

  /// 댓글 목록 조회 진행 중 여부. (시트 본문에 로딩 인디케이터 표시)
  bool get isLoading => _loading;

  /// 목록 교체 세대. [reload] 로 목록을 갈아끼울 때마다 1씩 늘어, 노출 개수를
  /// 첫 페이지로 되돌리는 신호로 쓴다.
  int get generation => _generation;

  /// 아직 서버에 반영되지 않은 댓글(전송 중·실패)이 남아 있는지 여부.
  bool get hasPending => _comments.any((c) => c.isPending);

  /// 댓글 목록을 조회해 서버 목록으로 갱신한다. 시트를 열 때마다 호출되어,
  /// 닫았다 다시 열면 최신 목록으로 재조회된다.
  ///
  /// 조회 중 기존 목록은 그대로 보여 주고(빈 목록일 때만 로딩 인디케이터),
  /// 성공하면 서버 목록으로 교체한다. 아직 서버에 없는 댓글(전송 중·실패)은
  /// 유실되지 않도록 서버 목록 뒤에 잇는다. 실패하면 기존 목록을 유지한다.
  Future<void> reload() async {
    if (_loading) return;

    _loading = true;
    _notify();
    final loaded = await onLoadComments();
    if (_disposed) return;

    _loading = false;
    // 실패(null)면 기존 목록을 그대로 두고 다음에 다시 열 때 재시도한다.
    if (loaded == null) {
      _notify();
      return;
    }
    // 서버 목록으로 갈아끼우되, 아직 서버에 없는 댓글만 뒤에 잇는다.
    // (인덱스가 아니라 상태로 고르므로, 조회 중 전송이 끝나 실제 댓글로
    // 바뀐 것은 서버 목록 쪽에만 남아 중복되지 않는다)
    final pending = _comments.where((c) => c.isPending).toList();
    _comments
      ..clear()
      ..addAll(loaded)
      ..addAll(pending);
    // 재조회로 목록이 바뀌고 스크롤도 맨 위로 돌아가므로 첫 페이지부터
    // 다시 드러낸다.
    _generation++;
    _notify();
    // 시트를 열면 최신 댓글(맨 아래)이 먼저 보이도록 바닥으로 이동한다.
    onListReloaded?.call();
  }

  /// 새 댓글을 낙관적으로 등록한다.
  ///
  /// 전송 중 댓글을 목록에 먼저 보여주고, 서버 응답이 오면 실제 댓글로
  /// 교체한다. 실패하면 목록에 남겨 두고 거기서 재전송할 수 있게 한다.
  /// (실패 안내 토스트는 호출 측이 띄운다)
  ///
  /// [nickname] · [profileImageUrl] · [justNowLabel] 은 임시 댓글의 표기에
  /// 쓴다. 실제 댓글과 같은 값을 넘겨야 교체되는 순간 글자가 튀지 않는다.
  Future<void> submit({
    required String content,
    required String nickname,
    required String? profileImageUrl,
    required String justNowLabel,
  }) async {
    // 서버 응답 전까지 자리를 지킬 임시 댓글. 응답이 오면 이 참조를 찾아
    // 교체한다. (PhotoComment 는 참조 동일성을 쓰므로 임시 id 가 필요 없다)
    final pending = PhotoComment(
      nickname: nickname,
      content: content,
      timeLabel: justNowLabel,
      profileImageUrl: profileImageUrl,
      isMine: true,
      sendStatus: CommentSendStatus.sending,
    );
    _comments.add(pending);
    _notify();
    onCommentAdded?.call();
    await _sendPending(pending);
  }

  /// 전송 실패 댓글의 '재전송'. 이미 보내는 중이면 무시한다. (연타 방지)
  Future<void> retry(PhotoComment comment) async {
    if (comment.sendStatus != CommentSendStatus.failed) return;
    final retrying = comment.copyWith(sendStatus: CommentSendStatus.sending);
    _replaceComment(comment, retrying);
    // 이미 보고 있는 자리라 스크롤은 건드리지 않는다.
    await _sendPending(retrying);
  }

  /// 전송 실패 댓글을 목록에서 치운다.
  /// 서버에 없는 댓글이라 삭제 API 를 부르지 않는다.
  /// (확인창은 화면이 먼저 띄우고, 확인된 경우에만 호출된다)
  void discard(PhotoComment comment) {
    _comments.remove(comment);
    _notify();
  }

  /// 수정 모드에서 전송했을 때 대상 댓글 내용을 [content] 로 바꾼다.
  /// 서버 반영에 성공하면 목록을 갱신하고 true 를 돌려준다.
  /// (실패면 false — 화면이 입력값·키보드를 유지해 바로 재시도하게 한다)
  Future<bool> applyEdit(PhotoComment original, String content) async {
    if (_editSubmitting) return false;
    _editSubmitting = true;
    final PhotoComment? updated;
    try {
      updated = await onEditComment(original, content);
    } finally {
      // 콜백이 예외를 던져도 가드를 반드시 풀어, 다음 전송이 막히지 않게 한다.
      _editSubmitting = false;
    }
    if (_disposed || updated == null) return false;
    _replaceComment(original, updated);
    return true;
  }

  /// 댓글 삭제 콜백을 호출하고, 성공하면 목록에서 제거한다.
  /// (삭제 확인창은 화면이 먼저 띄우고, 확인된 경우에만 호출된다)
  Future<void> delete(PhotoComment comment) async {
    final deleted = await onDeleteComment(comment);
    if (_disposed || !deleted) return;
    _comments.remove(comment);
    _notify();
  }

  /// 댓글 신고 콜백을 호출하고, 신고가 확정되면(true) 목록에서 즉시 제거한다.
  /// (낙관적 — 접수는 백그라운드로 진행되고, 실패하면 호출 측이 에러 토스트를
  /// 띄우며 다음 목록 조회 때 댓글이 되살아난다)
  Future<void> report(PhotoComment comment) async {
    final reported = await onReportComment(comment);
    if (_disposed || !reported) return;
    _comments.remove(comment);
    _notify();
  }

  /// 댓글 작성자 차단 콜백을 호출하고, 차단에 성공하면 목록을 재조회한다.
  /// (차단한 유저의 댓글은 호출 측 조회 필터가 걸러내므로 목록에서 사라진다)
  Future<void> block(PhotoComment comment) async {
    final blocked = await onBlockComment(comment);
    if (_disposed || !blocked) return;
    await reload();
  }

  /// 전송 중([CommentSendStatus.sending]) 댓글을 서버로 보내고, 결과에 따라
  /// 실제 댓글로 교체하거나 실패 상태로 되돌린다.
  /// (최초 전송·재전송 공용)
  Future<void> _sendPending(PhotoComment pending) async {
    final PhotoComment? created;
    try {
      created = await onSubmitComment(pending.content);
    } catch (_) {
      // 콜백이 예외를 던져도 목록이 '전송 중' 에 멈추지 않게 실패로 되돌린다.
      // (오류 안내는 호출 측 토스트가 맡는다)
      if (!_disposed) _markFailed(pending);
      rethrow;
    }
    if (_disposed) return;
    if (created == null) {
      _markFailed(pending);
      return;
    }
    _replaceComment(pending, created);
  }

  /// 전송 중 댓글을 실패 상태로 바꿔 '재전송' 을 띄운다.
  void _markFailed(PhotoComment pending) {
    _replaceComment(
      pending,
      pending.copyWith(sendStatus: CommentSendStatus.failed),
    );
  }

  /// 목록에서 [oldComment] 를 [newComment] 로 교체한다.
  void _replaceComment(PhotoComment oldComment, PhotoComment newComment) {
    final index = _comments.indexOf(oldComment);
    if (index < 0) return;
    _comments[index] = newComment;
    _notify();
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
