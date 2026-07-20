import 'dart:math' as math;

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

  /// 댓글 등록·수정 요청 진행 중 여부. (연속 전송 방지)
  /// 화면에 드러나지 않는 가드라서 갱신할 때 setState 를 부르지 않는다.
  bool _submitting = false;

  /// 댓글 목록 조회 진행 중 여부. (시트 본문에 로딩 인디케이터 표시)
  bool _loadingComments = false;

  /// 수정 중인 댓글. null 이면 새 댓글 입력 모드, 있으면 그 댓글을 수정하는
  /// 모드다. (입력창 위에 대상 댓글을 보여주고, 전송 시 등록 대신 수정한다)
  PhotoComment? _editingComment;

  @override
  void initState() {
    super.initState();
    // 키보드 높이 변화를 관찰한다. ([didChangeMetrics])
    WidgetsBinding.instance.addObserver(this);
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

  /// 입력 포커스를 해제한다. (부모가 시트를 닫을 때 키보드를 함께 내리는 용도)
  void unfocus() => _commentFocusNode.unfocus();

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
  /// 성공하면 서버 목록으로 교체한다. 조회 중 새로 등록한 댓글은 유실되지
  /// 않도록 서버 목록 뒤에 잇는다. 실패하면 기존 목록을 유지한다.
  Future<void> reload() async {
    if (_loadingComments) return;

    setState(() => _loadingComments = true);
    // 조회 시작 시점의 목록 길이. 조회 중 등록된 댓글을 가려내는 데 쓴다.
    final beforeCount = _comments.length;
    final loaded = await widget.onLoadComments();
    if (!mounted) return;
    setState(() {
      _loadingComments = false;
      // 실패(null)면 기존 목록을 그대로 두고 다음에 다시 열 때 재시도한다.
      if (loaded == null) return;
      // 조회 중 새로 등록된 댓글(있다면)만 서버 목록 뒤에 잇는다.
      final addedDuringLoad = _comments.sublist(beforeCount);
      _comments
        ..clear()
        ..addAll(loaded)
        ..addAll(addedDuringLoad);
    });
    // 시트를 열면 최신 댓글(맨 아래)이 먼저 보이도록 바닥으로 이동한다.
    if (loaded != null) _scrollCommentsToBottom();
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
  /// 서버에 등록하고 성공한 댓글만 목록에 추가한다.
  /// (실패 시 입력값을 유지해 재시도할 수 있게 한다)
  /// 전송에 성공하면 입력값을 비우고, 최신 댓글로 이동한 뒤 키보드를 내린다.
  Future<void> _submitComment(String text) async {
    final content = text.trim();
    if (content.isEmpty || _submitting) return;

    // 수정 모드면 등록 대신 수정으로 처리한다.
    final editing = _editingComment;
    if (editing != null) {
      await _applyEditComment(editing, content);
      return;
    }

    _submitting = true;
    final PhotoComment? created;
    try {
      created = await widget.onSubmitComment(content);
    } finally {
      // 콜백이 예외를 던져도 가드를 반드시 풀어, 다음 전송이 막히지 않게 한다.
      _submitting = false;
    }
    if (!mounted) return;
    // 실패(null)면 입력값·키보드를 유지해 바로 재시도할 수 있게 한다.
    if (created == null) return;
    _commentController.clear();
    _appendComment(created);
  }

  /// 새 댓글을 목록에 추가한다.
  ///
  /// 먼저 최신 댓글(맨 아래)로 이동한 뒤 시트를 원래 크기로 줄이고, 줄어드는
  /// 동안에도 계속 바닥에 붙여 최신 댓글이 이어져 보이게 한다.
  /// (키보드가 떠 있는 동안 잠깐 입력창 뒤에 가려지는 건 허용)
  void _appendComment(PhotoComment comment) {
    setState(() => _comments.add(comment));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1) 최신 댓글로 이동한다. (현재 크기 — 키보드가 떠 있을 수 있음)
      if (!_jumpToBottom()) return;
      // 2) 그다음 시트를 원래 크기로 줄인다.
      _commentFocusNode.unfocus();
      // 3) 줄어드는 동안(뷰포트 축소로 maxScrollExtent 증가) 계속 바닥에 붙인다.
      _pinCommentsToBottom();
    });
  }

  /// 시트가 원래 크기로 줄어드는 동안(약 [PhotoCommentSheet.duration]) 매 프레임
  /// 목록을 맨 아래로 붙여, 최신 댓글이 계속 바닥에 보이게 한다.
  /// (프레임 타임스탬프로 시간 측정 — 주사율과 무관)
  void _pinCommentsToBottom() {
    Duration? start;
    void pin(Duration timeStamp) {
      if (!_jumpToBottom()) return;
      start ??= timeStamp;
      if (timeStamp - start! < PhotoCommentSheet.duration) {
        WidgetsBinding.instance.addPostFrameCallback(pin);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback(pin);
  }

  /// 수정 모드에서 전송했을 때 대상 댓글 내용을 [content] 로 바꾼다.
  /// 서버 반영 후 성공한 댓글로 교체하고, 수정 모드를 끝낸다.
  Future<void> _applyEditComment(PhotoComment original, String content) async {
    _submitting = true;
    final PhotoComment? updated;
    try {
      updated = await widget.onEditComment(original, content);
    } finally {
      // 콜백이 예외를 던져도 가드를 반드시 풀어, 다음 전송이 막히지 않게 한다.
      _submitting = false;
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

  /// 댓글 목록을 애니메이션 없이 맨 아래로 옮긴다.
  ///
  /// 아직 스크롤이 붙지 않았거나 화면에서 사라진 뒤면 아무것도 하지 않고
  /// false 를 반환한다. (프레임 콜백 안에서 호출되므로 매번 확인이 필요하다)
  bool _jumpToBottom() {
    if (!mounted || !_commentScrollController.hasClients) return false;
    _commentScrollController.jumpTo(
      _commentScrollController.position.maxScrollExtent,
    );
    return true;
  }

  /// 다음 프레임에 댓글 목록을 맨 아래로 즉시 이동한다.
  /// (시트 오픈 시 최신 댓글을 먼저 보여주는 데 쓴다)
  void _scrollCommentsToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToBottom());
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
          // 헤더: 유저 닉네임 + 따라찍기 주제. (핸들과 간격 s7)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.s7,
              left: AppSpacing.s4,
              right: AppSpacing.s4,
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
      children: [
        for (final comment in _comments)
          CommentItem(
            comment: comment,
            onEdit: _startEditComment,
            onDelete: _handleDeleteComment,
            onReport: widget.onReportComment,
          ),
      ],
    );
  }

  /// 하단 입력 영역. (수정 모드면 입력창 위에 대상 댓글 배너)
  Widget _footer(double keyboardInset) {
    return Container(
      // 입력 바(발 부분)는 시트와 같은 base. (TextField 내부만 surface)
      color: AppColors.bgBase,
      padding: EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s4,
        top: AppSpacing.s3,
        // 홈 인디케이터 영역 회피분. 키보드가 올라온 만큼 줄여 패딩이
        // 튀지 않고 연속적으로 변한다.
        bottom:
            AppSpacing.s4 +
            math.max(0, MediaQuery.paddingOf(context).bottom - keyboardInset),
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
    );
  }
}
