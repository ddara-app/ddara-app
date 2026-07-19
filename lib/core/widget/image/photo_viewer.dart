import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.locked = false,
    this.onSubmitComment,
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

  /// 댓글 등록 콜백. 입력한 content 를 받아 등록하고, 성공 시 화면에 추가할
  /// [PhotoComment] 를, 실패 시 null 을 반환한다. null 이면 입력값을 유지해
  /// 재시도할 수 있게 한다. (실패 안내는 호출 측에서 처리)
  /// null 로 두면 API 연동 없이 메모리상에만 쌓는 임시 동작을 한다.
  final Future<PhotoComment?> Function(String content)? onSubmitComment;

  /// 잠긴 사진 여부. true 면 뷰어에서도 블러 + 가운데 자물쇠를 유지한다.
  /// (본인이 아직 업로드하지 않아 타인 사진이 잠긴 경우 — 댓글은 볼 수 있다)
  final bool locked;

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

  /// 댓글 목록 스크롤. (댓글 등록 시 맨 아래로 이동하는 데 쓴다)
  final ScrollController _commentScrollController = ScrollController();

  /// 댓글 입력값.
  final TextEditingController _commentController = TextEditingController();

  /// 입력 박스 어디를 눌러도 포커스가 잡히도록 직접 관리하는 포커스 노드.
  final FocusNode _commentFocusNode = FocusNode();

  /// 직전 프레임의 키보드 표시 여부. (키보드가 내려간 순간을 감지하는 데 쓴다)
  bool _keyboardWasVisible = false;

  /// 댓글 등록 요청 진행 중 여부. (연속 전송 방지)
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // 완전히 닫힌 순간에만 닫기 버튼·말풍선을 되살린다.
    _sheetController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() => _sheetVisible = false);
      }
    });
    // 포커스 변화에 맞춰 시트 높이를 다시 계산한다. (키보드가 실제로
    // 다 내려오기 전, 포커스가 풀리는 즉시 시트가 함께 줄어들도록)
    _commentFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _commentScrollController.dispose();
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

  /// 입력한 댓글을 등록한다.
  ///
  /// [PhotoViewer.onSubmitComment] 가 있으면 서버에 등록하고 성공한 댓글만
  /// 목록에 추가한다. (실패 시 입력값을 유지해 재시도할 수 있게 한다)
  /// 콜백이 없으면 메모리상에만 쌓는 임시 동작을 한다.
  Future<void> _submitComment(String text) async {
    final content = text.trim();
    if (content.isEmpty || _submitting) return;

    final onSubmit = widget.onSubmitComment;
    if (onSubmit == null) {
      // API 콜백이 없으면 메모리상에만 추가한다. (임시 동작)
      _appendComment(
        PhotoComment(
          nickname: widget.myNickname ?? '',
          content: content,
          timeLabel: AppLocalizations.of(context).timeAgoJustNow,
        ),
      );
      _commentController.clear();
      return;
    }

    setState(() => _submitting = true);
    final created = await onSubmit(content);
    if (!mounted) return;
    setState(() => _submitting = false);
    // 실패(null)면 입력값을 유지해 재시도할 수 있게 한다.
    if (created == null) return;
    _commentController.clear();
    _appendComment(created);
  }

  /// 댓글을 목록에 추가하고, 다음 프레임에 맨 아래로 스크롤한다.
  void _appendComment(PhotoComment comment) {
    setState(() => _comments.add(comment));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_commentScrollController.hasClients) return;
      _commentScrollController.animateTo(
        _commentScrollController.position.maxScrollExtent,
        duration: _duration,
        curve: Curves.easeOut,
      );
    });
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
    final rawPicture = ratio == null
        ? Image(image: widget.image, fit: BoxFit.contain)
        : AspectRatio(
            aspectRatio: ratio,
            child: Image(image: widget.image, fit: BoxFit.cover),
          );
    // 잠긴 사진은 갤러리 카드와 동일하게 블러 + 가운데 자물쇠를 유지한다.
    final Widget picture = widget.locked
        ? Stack(
            alignment: Alignment.center,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: rawPicture,
              ),
              const Icon(
                CupertinoIcons.lock_fill,
                size: 48,
                color: AppColors.textPrimary,
              ),
            ],
          )
        : rawPicture;

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
                // 아이콘 24 + 패딩 s3(12)×2 = 지름 48 원.
                padding: const EdgeInsets.all(AppSpacing.s3),
                decoration: const BoxDecoration(
                  color: AppColors.overlayScrim,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/images/ic_comment.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
      ],
    );

    final l10n = AppLocalizations.of(context);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    // 키보드가 올라오면 시트를 0.9까지 키우고, 입력 필드는 키보드 높이만큼
    // 위로 띄운다. (평소엔 0.65) 높이는 실제 인셋 대신 포커스 여부로 판단해,
    // 키보드가 내려가기 시작하는 순간부터 시트도 함께 줄어들게 한다.
    final sheetHeight =
        MediaQuery.sizeOf(context).height *
        (_commentFocusNode.hasFocus ? 0.9 : 0.65);

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
          // 댓글 바텀시트. (등장/퇴장·드래그는 진행도를 공유하는 SlideTransition)
          // 키보드 표시 여부에 따라 높이가 바뀌며, 그 변화는 부드럽게 애니메이션한다.
          AnimatedPositioned(
            duration: _duration,
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            height: sheetHeight,
            bottom: 0,
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
                              controller: _commentScrollController,
                              // 오른쪽은 s2. 아이콘 버튼 내부 여백 12를 더해
                              // 아이콘이 화면 끝에서 s5(20) 떨어지도록 맞춘다.
                              padding: const EdgeInsets.only(
                                left: AppSpacing.s4,
                                right: AppSpacing.s2,
                                top: AppSpacing.s2,
                                bottom: AppSpacing.s2,
                              ),
                              children: [
                                for (final comment in _comments)
                                  _CommentItem(comment: comment),
                              ],
                            ),
                    ),
                    // 하단 댓글 입력 필드. 키보드가 올라오면 시트는 그대로
                    // 두고 입력 필드만 키보드 위로 띄운다. (페인트 전용 이동
                    // 이라 매 프레임 재레이아웃 없음, 뒤 목록은 배경색으로
                    // 가린다)
                    Transform.translate(
                      offset: Offset(0, -keyboardInset),
                      child: Container(
                        color: AppColors.bgSurface,
                        padding: EdgeInsets.only(
                          left: AppSpacing.s4,
                          right: AppSpacing.s4,
                          top: AppSpacing.s3,
                          // 홈 인디케이터 영역 회피분. 키보드가 올라온 만큼
                          // 줄여 패딩이 튀지 않고 연속적으로 변한다.
                          bottom:
                              AppSpacing.s4 +
                              math.max(
                                0,
                                MediaQuery.paddingOf(context).bottom -
                                    keyboardInset,
                              ),
                        ),
                        child: _commentInput(l10n),
                      ),
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
        child: Row(
          children: [
            Expanded(
              child: CupertinoTextField(
                controller: _commentController,
                focusNode: _commentFocusNode,
                padding: EdgeInsets.zero,
                decoration: null,
                placeholder: l10n.photoViewerCommentHint,
                placeholderStyle: placeholderStyle,
                style: placeholderStyle.copyWith(color: AppColors.textPrimary),
                cursorColor: AppColors.accentDefault,
                // 서버 400(200자 초과)을 막기 위해 입력 단계에서 제한한다.
                maxLength: 200,
                textInputAction: TextInputAction.send,
                onSubmitted: _submitComment,
              ),
            ),
            // 입력값이 있을 때만 tail(전송) 아이콘을 띄운다. 탭하면 등록한다.
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _commentController,
              builder: (context, value, _) {
                if (value.text.trim().isEmpty) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: () => _submitComment(_commentController.text),
                  child: const Padding(
                    padding: EdgeInsets.only(left: AppSpacing.s2),
                    child: Icon(
                      CupertinoIcons.paperplane_fill,
                      size: 20,
                      color: AppColors.textDisabled,
                    ),
                  ),
                );
              },
            ),
          ],
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
          ProfileAvatar(size: 32, imageUrl: comment.profileImageUrl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: AppText.caption(
                        comment.nickname,
                        color: AppColors.textAccent,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s1,
                      ),
                      child: AppText.caption(
                        '·',
                        color: AppColors.textDisabled,
                      ),
                    ),





                    AppText.caption(
                      comment.timeLabel,
                      color: AppColors.textDisabled,
                    ),
                  ],
                ),
                AppText.body(
                  comment.content,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          AppBarIconButton(
            size: 20,
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.ellipsis_vertical,
              size: 20,
              color: AppColors.textPrimary,
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
  bool locked = false,
  Future<PhotoComment?> Function(String content)? onSubmitComment,
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
        locked: locked,
        onSubmitComment: onSubmitComment,
      ),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}
