import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/widget/profile_avatar.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 사진 뷰어 댓글 시트에 표시할 댓글 하나.
class PhotoComment {
  const PhotoComment({
    required this.nickname,
    required this.content,
    required this.timeLabel,
    this.profileImageUrl,
  });

  /// 작성자 닉네임.
  final String nickname;

  /// 댓글 내용.
  final String content;

  /// 작성 시각 라벨. (예: '3분 전' — 호출 측에서 포맷해 전달)
  final String timeLabel;

  /// 작성자 프로필 이미지 URL. null·빈 값이면 기본 아이콘.
  final String? profileImageUrl;
}

/// 이미지를 전체 화면으로 크게 보여주는 뷰어.
///
/// 핀치 줌/드래그로 확대·이동할 수 있고, 빈 곳을 탭하거나 닫기 버튼을 누르면
/// 닫힌다. 우하단 말풍선을 탭하면 이미지가 상단에 붙고 아래로 댓글 바텀시트가
/// 올라온다. (시트가 열린 동안 닫기 버튼·말풍선은 숨김, 시트는 아래로 드래그해
/// 닫을 수 있다) 목록 카드에서 [showPhotoViewer] 로 띄운다.
class PhotoViewer extends StatefulWidget {
  const PhotoViewer({
    super.key,
    required this.image,
    this.heroTag,
    this.aspectRatio,
    this.title,
    this.body,
    this.comments = const [],
    this.myNickname,
  });

  /// 크게 보여줄 이미지.
  final ImageProvider image;

  /// 바텀시트 헤더 제목. (이미지를 올린 유저 닉네임)
  final String? title;

  /// 바텀시트 헤더 본문. (해당 따라찍기 주제)
  final String? body;

  /// 댓글 시트에 표시할 댓글 목록.
  final List<PhotoComment> comments;

  /// 본인 닉네임. (내가 작성한 댓글의 작성자 표기에 쓴다)
  final String? myNickname;

  /// 목록 카드와 뷰어를 잇는 Hero 전환 태그. null 이면 전환 애니메이션 없이 표시.
  final Object? heroTag;

  /// 카드에서 보이던 프레임 그대로 보여줄 때 쓰는 카드의 가로:세로 비율.
  /// 지정하면 이 비율의 프레임에 cover 로 잘라 담아, 카드에서 잘렸던 부분이
  /// 추가로 드러나지 않는다. null 이면 원본 전체를 보여준다. (contain)
  final double? aspectRatio;

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer>
    with SingleTickerProviderStateMixin {
  /// 이미지 도킹·시트 등장 애니메이션 시간.
  static const _duration = Duration(milliseconds: 250);

  /// 드래그를 놓았을 때 이 속도(px/s)보다 빠르면 진행도와 무관하게 닫는다.
  static const _dismissVelocity = 700.0;

  /// 시트 진행도. (0 = 닫힘 · 1 = 열림)
  /// 드래그 중에는 값을 직접 갱신해 이미지 위치·시트가 손가락을 따라온다.
  late final AnimationController _sheetController = AnimationController(
    vsync: this,
    duration: _duration,
  );

  /// 시트 슬라이드 위치. ((0,1) = 자기 높이만큼 아래 → 화면 밖으로 숨김)
  late final Animation<Offset> _sheetOffset = _sheetController.drive(
    Tween(begin: const Offset(0, 1), end: Offset.zero),
  );

  /// 이미지 정렬. (시트 진행도에 따라 가운데 ↔ 상단을 오간다)
  late final Animation<Alignment> _imageAlignment = _sheetController.drive(
    AlignmentTween(begin: Alignment.center, end: Alignment.topCenter),
  );

  /// 댓글 바텀시트 표시 여부. (닫힘 애니메이션이 끝나야 false 가 된다 —
  /// 닫기 버튼·말풍선의 Gone 상태 판단에 쓴다)
  bool _sheetVisible = false;

  /// 화면에 표시 중인 댓글 목록. 전달받은 목록으로 시작해, 입력한 댓글을
  /// 메모리상에서만 뒤에 쌓는다. (API 연동 전 임시 동작)
  late final List<PhotoComment> _comments = [...widget.comments];

  /// 댓글 입력값.
  final TextEditingController _commentController = TextEditingController();

  /// 입력 박스 어디를 눌러도 포커스가 잡히도록 직접 관리하는 포커스 노드.
  final FocusNode _commentFocusNode = FocusNode();

  /// 직전 프레임의 키보드 표시 여부. (키보드가 내려간 순간을 감지하는 데 쓴다)
  bool _keyboardWasVisible = false;

  @override
  void initState() {
    super.initState();
    // 완전히 닫힌 순간에만 닫기 버튼·말풍선을 되살린다.
    _sheetController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() => _sheetVisible = false);
      }
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  /// 시트를 연다.
  void _openSheet() {
    setState(() => _sheetVisible = true);
    _sheetController.animateTo(1, curve: Curves.easeInOut);
  }

  /// 시트를 닫는다. (키보드가 떠 있으면 함께 내린다)
  void _closeSheet() {
    _commentFocusNode.unfocus();
    _sheetController.animateBack(0, curve: Curves.easeInOut);
  }

  /// 시트 드래그 → 진행도를 손가락 이동량에 비례해 갱신한다.
  /// (이미지도 같은 진행도를 공유하므로 함께 원래 자리로 돌아간다)
  void _onSheetDragUpdate(DragUpdateDetails details, double sheetHeight) {
    _sheetController.value -= details.primaryDelta! / sheetHeight;
  }

  /// 입력한 댓글을 목록에 추가한다. (메모리상 임시 저장 — API 연동 전)
  /// TODO: 댓글 등록 API 연동. (작성자 정보 포함)
  void _submitComment(String text) {
    final content = text.trim();
    if (content.isEmpty) return;
    setState(() {
      _comments.add(
        PhotoComment(
          nickname: widget.myNickname ?? '',
          content: content,
          timeLabel: AppLocalizations.of(context).timeAgoJustNow,
        ),
      );
    });
    _commentController.clear();
  }

  /// 드래그 종료 → 빠르게 내렸거나 절반 아래로 내려갔으면 닫고, 아니면 복귀.
  void _onSheetDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity > _dismissVelocity || _sheetController.value < 0.5) {
      _closeSheet();
    } else {
      _sheetController.animateTo(1, curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratio = widget.aspectRatio;
    final picture = ratio == null
        ? Image(image: widget.image, fit: BoxFit.contain)
        : AspectRatio(
            aspectRatio: ratio,
            child: Image(image: widget.image, fit: BoxFit.cover),
          );

    // 핀치 줌/드래그로 확대·이동.
    Widget content = InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: picture,
    );
    if (widget.heroTag != null) {
      content = Hero(tag: widget.heroTag!, child: content);
    }

    // 이미지 프레임 우측 하단의 말풍선 아이콘. (확대·이동과 무관하게 고정,
    // 시트가 열린 동안엔 숨김)
    content = Stack(
      children: [
        content,
        if (!_sheetVisible)
          Positioned(
            right: AppSpacing.s3,
            bottom: AppSpacing.s3,
            child: GestureDetector(
              onTap: _openSheet,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.s2),
                decoration: const BoxDecoration(
                  color: AppColors.overlayScrim,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.chat_bubble,
                  size: 24,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
      ],
    );

    final l10n = AppLocalizations.of(context);
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.5;
    // 키보드가 올라오면 시트도 그만큼 함께 올린다.
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    // 키보드가 (뒤로가기·스와이프 등으로) 내려가면 입력 포커스도 해제한다.
    // (포커스 변경은 빌드 중 상태를 건드리므로 프레임 이후로 미룬다)
    if (_keyboardWasVisible &&
        keyboardInset == 0 &&
        _commentFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _commentFocusNode.unfocus();
      });
    }
    _keyboardWasVisible = keyboardInset > 0;

    // OS 뒤로가기(안드로이드 버튼·iOS 스와이프): 시트가 열려 있으면 시트만
    // 닫고, 닫힌 상태에서 한 번 더 하면 뷰어가 pop 된다.
    return PopScope(
      canPop: !_sheetVisible,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _closeSheet();
      },
      child: Stack(
        children: [
          // 빈 곳 탭 → 시트가 열려 있으면 시트만 닫고, 아니면 뷰어를 닫는다.
          // (핀치/드래그는 InteractiveViewer 가 처리)
          Positioned.fill(
            child: GestureDetector(
              onTap: () =>
                  _sheetVisible ? _closeSheet() : Navigator.of(context).pop(),
              child: AlignTransition(
                alignment: _imageAlignment,
                child: content,
              ),
            ),
          ),
          // 우상단 닫기 버튼. (시트가 열린 동안엔 숨김)
          if (!_sheetVisible)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: CupertinoButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Icon(
                    CupertinoIcons.xmark,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          // 댓글 바텀시트. (등장/퇴장·드래그는 진행도를 공유하는 SlideTransition,
          // 키보드 추적은 Positioned 가 매 프레임 즉시 반영해 같은 속도로 움직인다)
          Positioned(
            left: 0,
            right: 0,
            height: sheetHeight,
            bottom: keyboardInset,
            child: SlideTransition(
              position: _sheetOffset,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg),
                  ),
                ),
                child: Column(
                  children: [
                    // 핸들·헤더 영역만 아래로 드래그해 시트를 닫을 수 있다.
                    // (댓글 목록이 들어갈 본문 스크롤과의 충돌 방지)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragStart: (_) => _commentFocusNode.unfocus(),
                      onVerticalDragUpdate: (details) =>
                          _onSheetDragUpdate(details, sheetHeight),
                      onVerticalDragEnd: _onSheetDragEnd,
                      child: Column(
                        children: [
                          // 상단 그랩 핸들.
                          Container(
                            width: 36,
                            height: 4,
                            margin: const EdgeInsets.only(top: AppSpacing.s3),
                            decoration: BoxDecoration(
                              color: AppColors.borderStrong,
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
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
                                  child: AppText.headlineLarge(
                                    widget.title ?? '',
                                  ),
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
                    ),
                    // 본문: 댓글이 없으면 안내 문구, 있으면 스크롤 목록.
                    Expanded(
                      child: _comments.isEmpty
                          ? Center(
                              child: AppText.body(
                                l10n.photoViewerCommentEmpty,
                                color: AppColors.textSecondary,
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.s4,
                                vertical: AppSpacing.s2,
                              ),
                              children: [
                                for (final comment in _comments)
                                  _CommentItem(comment: comment),
                              ],
                            ),
                    ),
                    // 하단 고정 댓글 입력 필드.
                    Padding(
                      padding: EdgeInsets.only(
                        left: AppSpacing.s4,
                        right: AppSpacing.s4,
                        top: AppSpacing.s3,
                        // 키보드가 없을 때만 홈 인디케이터 영역을 피한다.
                        bottom:
                            AppSpacing.s4 +
                            (keyboardInset > 0
                                ? 0
                                : MediaQuery.paddingOf(context).bottom),
                      ),
                      child: _commentInput(l10n),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 알약 형태의 댓글 입력 필드.
  Widget _commentInput(AppLocalizations l10n) {
    final placeholderStyle = AppTypography.body.copyWith(
      color: AppColors.textDisabled,
    );
    return GestureDetector(
      // 패딩 등 박스 빈 영역을 눌러도 입력에 포커스가 잡히도록.
      behavior: HitTestBehavior.opaque,
      onTap: _commentFocusNode.requestFocus,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s5,
          vertical: AppSpacing.s4,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.5, color: AppColors.borderStrong),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
        child: CupertinoTextField(
          controller: _commentController,
          focusNode: _commentFocusNode,
          padding: EdgeInsets.zero,
          decoration: null,
          placeholder: l10n.photoViewerCommentHint,
          placeholderStyle: placeholderStyle,
          style: placeholderStyle.copyWith(color: AppColors.textPrimary),
          cursorColor: AppColors.accentDefault,
          textInputAction: TextInputAction.send,
          onSubmitted: _submitComment,
        ),
      ),
    );
  }
}

/// 댓글 시트의 댓글 한 줄. (좌: 프로필 아바타 · 우: 닉네임/시간 + 내용)
class _CommentItem extends StatelessWidget {
  const _CommentItem({required this.comment});

  /// 표시할 댓글.
  final PhotoComment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacing.s4,
        children: [
          ProfileAvatar(size: 36, imageUrl: comment.profileImageUrl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.body(comment.nickname, color: AppColors.textAccent),
                    AppText.body(
                      comment.timeLabel,
                      color: AppColors.textDisabled,
                    ),
                  ],
                ),
                AppText.body(comment.content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 이미지를 전체 화면 라이트박스로 띄운다. (검은 배경이 페이드로 나타남)
Future<void> showPhotoViewer(
  BuildContext context, {
  required ImageProvider image,
  Object? heroTag,
  double? aspectRatio,
  String? title,
  String? body,
  List<PhotoComment> comments = const [],
  String? myNickname,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      // 배경을 반투명하게 두어 하단 화면이 페이드로 덮이도록 한다.
      opaque: false,
      barrierColor: AppColors.bgBase,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => PhotoViewer(
        image: image,
        heroTag: heroTag,
        aspectRatio: aspectRatio,
        title: title,
        body: body,
        comments: comments,
        myNickname: myNickname,
      ),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}
