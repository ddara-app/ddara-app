import 'dart:math' as math;

import 'package:ddara/core/design_system/component/divider/app_divider.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/image/comment/comment_editing_banner.dart';
import 'package:ddara/core/widget/image/comment/comment_input_field.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/core/widget/image/comment/photo_comment_item.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 사진 뷰어 하단에서 올라오는 댓글 바텀시트.
///
/// 시트의 등장/퇴장은 부모(사진 뷰어)가 가진 진행도를 [position] 으로 받아
/// 따르고, 시트를 아래로 드래그하면 [onDragProgress]·[onDragEnd] 로 그 진행도를
/// 되돌려 준다. (이미지 도킹과 같은 진행도를 공유하기 위함)
///
/// 시트 안쪽 — 댓글 조회·등록·수정·삭제, 입력창과 키보드 대응, 높이 계산은
/// 모두 이 위젯이 스스로 처리한다. 부모는 [PhotoCommentSheetState.reload] 로
/// 목록 재조회를, [PhotoCommentSheetState.unfocus] 로 키보드 내림을 요청한다.
class PhotoCommentSheet extends StatefulWidget {
  const PhotoCommentSheet({
    super.key,
    required this.position,
    required this.onDragProgress,
    required this.onDragEnd,
    required this.onSubmitComment,
    required this.onLoadComments,
    required this.onEditComment,
    required this.onDeleteComment,
    required this.onReportComment,
    this.title,
    this.body,
    this.comments = const [],
    this.myNickname = '',
    this.myProfileImageUrl,
    this.locked = false,
    this.loadOnInit = false,
  });

  /// 시트 등장/퇴장·드래그 애니메이션 시간. (부모의 이미지 도킹과 공유)
  static const duration = Duration(milliseconds: 250);

  /// 시트 슬라이드 위치. ((0,1) = 자기 높이만큼 아래 → 화면 밖으로 숨김)
  final Animation<Offset> position;

  /// 시트를 드래그한 만큼의 진행도 변화량. 부모가 자기 진행도에 더하면 된다.
  /// (아래로 끌면 음수 — 진행도가 줄어 시트가 닫히는 쪽으로 간다)
  final void Function(double delta) onDragProgress;

  /// 시트 드래그 종료. 부모가 닫을지 되돌릴지 판단한다.
  final void Function(DragEndDetails details) onDragEnd;

  /// 시트 헤더 제목. (이미지를 올린 유저 닉네임)
  final String? title;

  /// 시트 헤더 본문. (해당 따라찍기 주제)
  final String? body;

  /// 시트에 표시할 초기 댓글 목록.
  final List<PhotoComment> comments;

  /// 본인 닉네임. 낙관적 업데이트로 먼저 보여줄 '전송 중' 댓글의 작성자 표기에
  /// 쓴다. 서버가 돌려준 댓글로 교체될 때 글자가 바뀌지 않도록, 실제 댓글과
  /// 같은 닉네임을 넘겨야 한다.
  final String myNickname;

  /// 본인 프로필 이미지 URL. '전송 중' 댓글의 아바타에 쓴다.
  /// null·빈 값이면 기본 아이콘.
  final String? myProfileImageUrl;

  /// 잠긴 사진 여부. true 면 서버가 작성을 막으므로 입력을 비활성화한다.
  final bool locked;

  /// 첫 프레임 이후 목록을 한 번 조회할지 여부.
  /// (시트가 열린 채로 시작하는 경우 — 댓글을 눌러 들어온 경우)
  final bool loadOnInit;

  /// 댓글 등록 콜백. 입력한 content 를 받아 등록하고, 성공 시 화면에 추가할
  /// [PhotoComment] 를, 실패 시 null 을 반환한다. null 이면 입력값을 유지해
  /// 재시도할 수 있게 한다. (실패 안내는 호출 측에서 처리)
  final Future<PhotoComment?> Function(String content) onSubmitComment;

  /// 댓글 목록 조회 콜백. 시트를 열 때마다 호출해 목록을 채운다.
  /// 성공 시 표시할 목록을, 실패 시 null 을 반환한다. (실패 안내는 호출 측에서
  /// 처리하고, 다시 열면 재시도한다)
  final Future<List<PhotoComment>?> Function() onLoadComments;

  /// 내 댓글 수정 적용 콜백. 수정 모드에서 전송하면 (대상 댓글, 새 내용) 으로
  /// 호출된다. 성공 시 갱신된 댓글을, 실패 시 null 을 반환해야 한다.
  final Future<PhotoComment?> Function(PhotoComment comment, String newContent)
  onEditComment;

  /// 내 댓글 더보기 메뉴 - '삭제하기' 콜백. 삭제에 성공하면 true 를 반환해야
  /// 하며, true 일 때 목록에서 해당 댓글을 제거한다.
  final Future<bool> Function(PhotoComment comment) onDeleteComment;

  /// 상대 댓글 더보기 메뉴 - '신고하기' 콜백.
  final void Function(PhotoComment comment) onReportComment;

  @override
  State<PhotoCommentSheet> createState() => PhotoCommentSheetState();
}

class PhotoCommentSheetState extends State<PhotoCommentSheet>
    with WidgetsBindingObserver {
  /// 헤더 구분선이 나타나고 사라지는 시간.
  /// 스크롤에 붙어 반응해야 하므로 시트 애니메이션보다 짧게 둔다.
  static const _dividerFadeDuration = Duration(milliseconds: 150);

  /// 화면에 표시 중인 댓글 목록. 전달받은 목록으로 시작해, [reload] 로 서버
  /// 목록을 받아 교체하고, 등록·수정·삭제 결과를 반영한다.
  late final List<PhotoComment> _comments = [...widget.comments];

  /// 댓글 목록 스크롤. (댓글 등록 시 맨 아래로 이동하는 데 쓴다)
  final ScrollController _commentScrollController = ScrollController();

  /// 댓글 입력값.
  final TextEditingController _commentController = TextEditingController();

  /// 입력 박스 어디를 눌러도 포커스가 잡히도록 직접 관리하는 포커스 노드.
  final FocusNode _commentFocusNode = FocusNode();

  /// 직전에 관찰한 키보드 표시 여부. (키보드가 내려간 '순간' 을 가려내는 데 쓴다)
  bool _keyboardWasVisible = false;

  /// 댓글 수정 요청 진행 중 여부. (연속 전송 방지)
  /// 화면에 드러나지 않는 가드라서 갱신할 때 setState 를 부르지 않는다.
  /// (등록은 낙관적 업데이트라 댓글별 [PhotoComment.sendStatus] 로 가려낸다)
  bool _editSubmitting = false;

  /// 댓글 목록 조회 진행 중 여부. (시트 본문에 로딩 인디케이터 표시)
  bool _loadingComments = false;

  /// 댓글 목록이 맨 위에서 벗어났는지 여부.
  /// (헤더 아래 구분선을 스크롤된 동안에만 보여주는 데 쓴다)
  bool _bodyScrolled = false;

  /// 수정 중인 댓글. null 이면 새 댓글 입력 모드, 있으면 그 댓글을 수정하는
  /// 모드다. (입력창 위에 대상 댓글을 보여주고, 전송 시 등록 대신 수정한다)
  PhotoComment? _editingComment;

  @override
  void initState() {
    super.initState();
    // 키보드 높이 변화를 관찰한다. ([didChangeMetrics])
    WidgetsBinding.instance.addObserver(this);
    // 목록이 맨 위를 벗어나는 순간에만 헤더 구분선을 켠다.
    _commentScrollController.addListener(_onBodyScroll);
    // 포커스 변화에 맞춰 시트 높이를 다시 계산한다. (키보드가 실제로
    // 다 내려오기 전, 포커스가 풀리는 즉시 시트가 함께 줄어들도록)
    _commentFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
    // 시트가 열린 채로 시작하면 목록을 채워 둔다.
    // 조회는 setState 를 부르므로 첫 프레임 이후로 미룬다.
    if (widget.loadOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) reload();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _commentScrollController.dispose();
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  /// 목록 스크롤이 맨 위를 오갈 때만 헤더 구분선을 켜고 끈다.
  /// (스크롤 중 매 픽셀마다 setState 하지 않도록 값이 바뀔 때만 갱신한다)
  void _onBodyScroll() {
    final scrolled =
        _commentScrollController.hasClients &&
        _commentScrollController.offset > 0;
    if (scrolled == _bodyScrolled || !mounted) return;
    setState(() => _bodyScrolled = scrolled);
  }

  /// 입력 포커스를 해제한다. (부모가 시트를 닫을 때 키보드를 함께 내리는 용도)
  void unfocus() => _commentFocusNode.unfocus();

  /// 아직 서버에 반영되지 않은 댓글(전송 중·실패)이 남아 있는지 여부.
  ///
  /// 뷰어가 닫히면 이 댓글들은 함께 사라지므로, 부모가 이 값을 보고 나가기
  /// 전에 확인창을 띄운다. (시트를 닫는 것만으로는 사라지지 않는다 —
  /// 시트는 화면 밖으로 밀릴 뿐 State 가 유지된다)
  bool get hasPendingComments => _comments.any((c) => c.isPending);

  /// 키보드가 (뒤로가기·스와이프 등으로) 내려가면 입력 포커스도 해제한다.
  /// 포커스가 남아 있으면 시트가 커진 높이(0.9)를 유지해 버리기 때문이다.
  ///
  /// 높이는 크기 비교만 하므로 [View] 의 물리 픽셀 값을 그대로 쓴다.
  /// (이 콜백은 MediaQuery 가 갱신되기 전에 불릴 수 있어 View 에서 직접 읽는다)
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final keyboardVisible = View.of(context).viewInsets.bottom > 0;
    if (_keyboardWasVisible && !keyboardVisible && _commentFocusNode.hasFocus) {
      _commentFocusNode.unfocus();
    }
    _keyboardWasVisible = keyboardVisible;
  }

  /// 댓글 목록을 조회해 서버 목록으로 갱신한다. 시트를 열 때마다 호출되어,
  /// 닫았다 다시 열면 최신 목록으로 재조회된다.
  ///
  /// 조회 중 기존 목록은 그대로 보여 주고(빈 목록일 때만 로딩 인디케이터),
  /// 성공하면 서버 목록으로 교체한다. 아직 서버에 없는 댓글(전송 중·실패)은
  /// 유실되지 않도록 서버 목록 뒤에 잇는다. 실패하면 기존 목록을 유지한다.
  Future<void> reload() async {
    if (_loadingComments) return;

    setState(() => _loadingComments = true);
    final loaded = await widget.onLoadComments();
    if (!mounted) return;
    setState(() {
      _loadingComments = false;
      // 실패(null)면 기존 목록을 그대로 두고 다음에 다시 열 때 재시도한다.
      if (loaded == null) return;
      // 서버 목록으로 갈아끼우되, 아직 서버에 없는 댓글만 뒤에 잇는다.
      // (인덱스가 아니라 상태로 고르므로, 조회 중 전송이 끝나 실제 댓글로
      // 바뀐 것은 서버 목록 쪽에만 남아 중복되지 않는다)
      final pending = _comments.where((c) => c.isPending).toList();
      _comments
        ..clear()
        ..addAll(loaded)
        ..addAll(pending);
    });
    // 시트를 열면 최신 댓글(맨 아래)이 먼저 보이도록 바닥으로 이동한다.
    if (loaded != null) _scrollToNewest();
  }

  /// 댓글 [comment] 를 수정 모드로 전환한다. 입력창에 기존 내용을 채우고
  /// 커서를 끝에 둔 뒤 포커스를 줘 키보드를 올린다. (입력창 위에 대상 댓글 표시)
  void _startEditComment(PhotoComment comment) {
    setState(() => _editingComment = comment);
    _commentController.value = TextEditingValue(
      text: comment.content,
      selection: TextSelection.collapsed(offset: comment.content.length),
    );
    _commentFocusNode.requestFocus();
  }

  /// 수정 모드를 끝낸다. (입력값·키보드를 정리)
  void _exitEditComment() {
    setState(() => _editingComment = null);
    _commentController.clear();
    _commentFocusNode.unfocus();
  }

  /// 입력한 댓글을 등록하거나(새 댓글), 수정 모드면 수정한다.
  /// (키보드의 전송 버튼·입력창 tail 아이콘 공용)
  ///
  /// 낙관적 업데이트 — 전송 중 댓글을 목록에 먼저 보여주고 입력값을 즉시 비운
  /// 뒤, 서버 응답이 오면 실제 댓글로 교체한다. 실패하면 목록에 남겨 두고
  /// 거기서 재전송할 수 있게 한다. (실패 안내 토스트는 호출 측이 띄운다)
  ///
  /// 입력값을 즉시 비우므로 연타로 같은 내용이 두 번 나가지 않는다.
  Future<void> _submitComment(String text) async {
    final content = text.trim();
    if (content.isEmpty) return;

    // 수정 모드면 등록 대신 수정으로 처리한다.
    final editing = _editingComment;
    if (editing != null) {
      await _applyEditComment(editing, content);
      return;
    }

    // 서버 응답 전까지 자리를 지킬 임시 댓글. 응답이 오면 이 참조를 찾아
    // 교체한다. (PhotoComment 는 참조 동일성을 쓰므로 임시 id 가 필요 없다)
    // 작성자·시각을 실제 댓글과 같게 채워, 교체되는 순간 글자가 튀지 않게 한다.
    // (방금 등록한 댓글이라 서버의 시간 라벨도 '방금 전' 이 된다)
    final pending = PhotoComment(
      nickname: widget.myNickname,
      content: content,
      timeLabel: AppLocalizations.of(context).timeAgoJustNow,
      profileImageUrl: widget.myProfileImageUrl,
      isMine: true,
      sendStatus: CommentSendStatus.sending,
    );
    _commentController.clear();
    _appendComment(pending);
    await _sendPending(pending);
  }

  /// 전송 중([CommentSendStatus.sending]) 댓글을 서버로 보내고, 결과에 따라
  /// 실제 댓글로 교체하거나 실패 상태로 되돌린다.
  /// (최초 전송·재전송 공용)
  Future<void> _sendPending(PhotoComment pending) async {
    final PhotoComment? created;
    try {
      created = await widget.onSubmitComment(pending.content);
    } catch (_) {
      // 콜백이 예외를 던져도 목록이 '전송 중' 에 멈추지 않게 실패로 되돌린다.
      // (오류 안내는 호출 측 토스트가 맡는다)
      if (mounted) _markFailed(pending);
      rethrow;
    }
    if (!mounted) return;
    if (created == null) {
      _markFailed(pending);
      return;
    }
    _replaceComment(pending, created);
  }

  /// 전송 실패 댓글의 '재전송'. 이미 보내는 중이면 무시한다. (연타 방지)
  Future<void> _retryComment(PhotoComment comment) async {
    if (comment.sendStatus != CommentSendStatus.failed) return;
    final retrying = comment.copyWith(sendStatus: CommentSendStatus.sending);
    _replaceComment(comment, retrying);
    // 이미 보고 있는 자리라 스크롤은 건드리지 않는다.
    await _sendPending(retrying);
  }

  /// 전송 실패 댓글을 목록에서 치운다.
  /// 서버에 없는 댓글이라 삭제 API 를 부르지 않는다.
  /// (확인창은 [CommentItem] 이 먼저 띄우고, 확인된 경우에만 호출된다)
  void _discardComment(PhotoComment comment) {
    setState(() => _comments.remove(comment));
  }

  /// 전송 중 댓글을 실패 상태로 바꿔 '재전송' 을 띄운다.
  void _markFailed(PhotoComment pending) {
    _replaceComment(
      pending,
      pending.copyWith(sendStatus: CommentSendStatus.failed),
    );
  }

  /// 새 댓글을 목록에 추가한다.
  ///
  /// 최신 댓글(맨 위)로 이동한 뒤 시트를 원래 크기로 줄인다.
  /// 최상단(0)에 붙어 있으면 시트 크기가 변해도 위치가 흔들리지 않으므로,
  /// 줄어드는 동안 따로 붙잡아 둘 필요가 없다.
  void _appendComment(PhotoComment comment) {
    setState(() => _comments.add(comment));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_jumpToNewest()) return;
      _commentFocusNode.unfocus();
    });
  }

  /// 수정 모드에서 전송했을 때 대상 댓글 내용을 [content] 로 바꾼다.
  /// 서버 반영 후 성공한 댓글로 교체하고, 수정 모드를 끝낸다.
  Future<void> _applyEditComment(PhotoComment original, String content) async {
    if (_editSubmitting) return;
    _editSubmitting = true;
    final PhotoComment? updated;
    try {
      updated = await widget.onEditComment(original, content);
    } finally {
      // 콜백이 예외를 던져도 가드를 반드시 풀어, 다음 전송이 막히지 않게 한다.
      _editSubmitting = false;
    }
    if (!mounted) return;
    // 실패(null)면 입력값·키보드를 유지해 바로 재시도할 수 있게 한다.
    if (updated == null) return;
    _replaceComment(original, updated);
    _exitEditComment();
  }

  /// 목록에서 [oldComment] 를 [newComment] 로 교체한다.
  void _replaceComment(PhotoComment oldComment, PhotoComment newComment) {
    final index = _comments.indexOf(oldComment);
    if (index < 0) return;
    setState(() => _comments[index] = newComment);
  }

  /// 댓글 삭제 콜백을 호출하고, 성공하면 목록에서 제거한다.
  /// (삭제 확인창은 [CommentItem] 이 먼저 띄우고, 확인된 경우에만 호출된다)
  Future<void> _handleDeleteComment(PhotoComment comment) async {
    final deleted = await widget.onDeleteComment(comment);
    if (!mounted || !deleted) return;
    setState(() => _comments.remove(comment));
  }

  /// 댓글 목록을 애니메이션 없이 최신 댓글 쪽으로 옮긴다.
  /// 최신이 맨 위에 오도록 그리므로 목표는 스크롤 최상단(0)이다.
  ///
  /// 아직 스크롤이 붙지 않았거나 화면에서 사라진 뒤면 아무것도 하지 않고
  /// false 를 반환한다. (프레임 콜백 안에서 호출되므로 매번 확인이 필요하다)
  bool _jumpToNewest() {
    if (!mounted || !_commentScrollController.hasClients) return false;
    _commentScrollController.jumpTo(0);
    return true;
  }

  /// 다음 프레임에 댓글 목록을 최신 댓글 쪽으로 즉시 이동한다.
  /// (시트 오픈 시 최신 댓글을 먼저 보여주는 데 쓴다)
  void _scrollToNewest() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToNewest());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    // 키보드가 올라오면 시트를 0.9까지 키우고, 입력 필드는 키보드 높이만큼
    // 위로 띄운다. (평소엔 0.65) 높이는 실제 인셋 대신 포커스 여부로 판단해,
    // 키보드가 내려가기 시작하는 순간부터 시트도 함께 줄어들게 한다.
    final sheetHeight =
        MediaQuery.sizeOf(context).height *
        (_commentFocusNode.hasFocus ? 0.9 : 0.65);

    // 키보드 표시 여부에 따라 높이가 바뀌며, 그 변화는 부드럽게 애니메이션한다.
    return AnimatedPositioned(
      duration: PhotoCommentSheet.duration,
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      height: sheetHeight,
      bottom: 0,
      child: SlideTransition(
        position: widget.position,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.bgBase,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
          child: Column(
            children: [
              _header(sheetHeight),
              // 헤더와 목록의 경계. 목록이 맨 위에 있을 때는 감춰 두고,
              // 스크롤해 댓글이 헤더 밑으로 들어가기 시작하면 드러낸다.
              // (자리는 항상 차지해 나타날 때 본문이 밀리지 않는다)
              AnimatedOpacity(
                duration: _dividerFadeDuration,
                opacity: _bodyScrolled && _comments.isNotEmpty ? 1 : 0,
                child: const AppDivider(color: AppColors.borderSubtle),
              ),
              // 본문: 조회 중이면 로딩, 댓글이 없으면 안내 문구,
              // 있으면 스크롤 목록.
              Expanded(child: _body(l10n)),
              // 하단 댓글 입력 필드. 키보드가 올라오면 시트는 그대로
              // 두고 입력 필드만 키보드 위로 띄운다. (페인트 전용 이동
              // 이라 매 프레임 재레이아웃 없음, 뒤 목록은 배경색으로
              // 가린다)
              Transform.translate(
                offset: Offset(0, -keyboardInset),
                child: _footer(keyboardInset),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 핸들·헤더 영역. 이 영역만 아래로 드래그해 시트를 닫을 수 있다.
  /// (댓글 목록 본문 스크롤과의 제스처 충돌 방지)
  Widget _header(double sheetHeight) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (_) => _commentFocusNode.unfocus(),
      // 손가락 이동량을 진행도 변화량으로 바꿔 부모에 넘긴다.
      // (이미지도 같은 진행도를 공유하므로 함께 원래 자리로 돌아간다)
      onVerticalDragUpdate: (details) =>
          widget.onDragProgress(-details.primaryDelta! / sheetHeight),
      onVerticalDragEnd: widget.onDragEnd,
      child: Column(
        children: [
          // 상단 그랩 핸들.
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: AppSpacing.s3),
            decoration: BoxDecoration(
              color: AppColors.borderStrong,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          // 헤더: 유저 닉네임 + 따라찍기 주제.
          // (핸들과 간격 s7, 아래 댓글 목록과 간격 s2)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.s7,
              left: AppSpacing.s4,
              right: AppSpacing.s4,
              bottom: AppSpacing.s2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: AppText.headlineLarge(widget.title ?? ''),
                ),
                SizedBox(
                  width: double.infinity,
                  child: AppText.body(widget.body ?? ''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 본문: 조회 중이면 로딩, 댓글이 없으면 안내 문구, 있으면 스크롤 목록.
  Widget _body(AppLocalizations l10n) {
    if (_loadingComments && _comments.isEmpty) {
      return const Center(child: CupertinoActivityIndicator());
    }
    if (_comments.isEmpty) {
      return Center(
        child: AppText.body(
          l10n.photoViewerCommentEmpty,
          color: AppColors.textSecondary,
        ),
      );
    }
    return ListView(
      controller: _commentScrollController,
      // 가장자리에서 더 당겨지는 바운스(overscroll)를 막고 끝에서 멈춘다.
      physics: const ClampingScrollPhysics(),
      // 오른쪽은 s2. 아이콘 버튼 내부 여백 12를 더해 아이콘이 화면 끝에서
      // s5(20) 떨어지도록 맞춘다.
      padding: const EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s2,
        top: AppSpacing.s2,
        bottom: AppSpacing.s2,
      ),
      // 최신 댓글이 맨 위에 오도록 역순으로 그린다.
      // (_comments 자체는 오래된 것 → 최신 순서를 유지한다)
      children: [
        for (final comment in _comments.reversed)
          CommentItem(
            comment: comment,
            onEdit: _startEditComment,
            onDelete: _handleDeleteComment,
            onReport: widget.onReportComment,
            onRetry: _retryComment,
            onDiscard: _discardComment,
          ),
      ],
    );
  }

  /// 하단 입력 영역. (수정 모드면 입력창 위에 대상 댓글 배너)
  ///
  /// 목록과의 경계에 구분선을 둔다. 스크롤된 댓글이 입력창 배경 뒤로 이어질 때
  /// 어디까지가 목록인지 드러난다.
  Widget _footer(double keyboardInset) {
    return Container(
      // 입력 바(발 부분)는 시트와 같은 base. (TextField 내부만 surface)
      color: AppColors.bgBase,
      padding: EdgeInsets.only(
        // 홈 인디케이터 영역 회피분. 키보드가 올라온 만큼 줄여 패딩이
        // 튀지 않고 연속적으로 변한다.
        bottom:
            AppSpacing.s4 +
            math.max(0, MediaQuery.paddingOf(context).bottom - keyboardInset),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 목록과 입력 영역의 경계. 좌우 여백 없이 시트 폭을 꽉 채운다.
          const AppDivider(color: AppColors.borderSubtle),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.s4,
              right: AppSpacing.s4,
              top: AppSpacing.s3,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 수정 모드면 입력창 위에 대상 댓글을 보여준다.
                if (_editingComment != null)
                  CommentEditingBanner(
                    comment: _editingComment!,
                    onCancel: _exitEditComment,
                  ),
                CommentInputField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  locked: widget.locked,
                  onSubmit: _submitComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
