import 'dart:ui' show ImageFilter;

import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/core/widget/image/comment/photo_comment_sheet.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 이미지를 전체 화면으로 크게 보여주는 뷰어.
///
/// 핀치 줌/드래그로 확대·이동할 수 있고, 빈 곳을 탭하거나 닫기 버튼을 누르면
/// 닫힌다. 우하단 말풍선을 탭하면 이미지가 상단에 붙고 아래로 댓글 바텀시트가
/// 올라온다. (시트가 열린 동안 닫기 버튼·말풍선은 숨김, 시트는 아래로 드래그해
/// 닫을 수 있다) 목록 카드에서 [showPhotoViewer] 로 띄운다.
///
/// 댓글 관련 동작은 모두 [PhotoCommentSheet] 가 맡고, 이 위젯은 이미지 표시와
/// 시트 등장/도킹 애니메이션의 진행도만 관리한다.
class PhotoViewer extends StatefulWidget {
  const PhotoViewer({
    super.key,
    required this.image,
    required this.onSubmitComment,
    required this.onLoadComments,
    required this.onEditComment,
    required this.onDeleteComment,
    required this.onReportComment,
    required this.onBlockComment,
    this.heroTag,
    this.aspectRatio,
    this.title,
    this.body,
    this.comments = const [],
    this.myNickname = '',
    this.myProfileImageUrl,
    this.locked = false,
    this.openCommentSheet = false,
    this.commentUnread = false,
  });

  /// 크게 보여줄 이미지.
  final ImageProvider image;

  /// 바텀시트 헤더 제목. (이미지를 올린 유저 닉네임)
  final String? title;

  /// 바텀시트 헤더 본문. (해당 따라찍기 주제)
  final String? body;

  /// 댓글 시트에 표시할 댓글 목록.
  final List<PhotoComment> comments;

  /// 본인 닉네임. → [PhotoCommentSheet.myNickname]
  final String myNickname;

  /// 본인 프로필 이미지 URL. → [PhotoCommentSheet.myProfileImageUrl]
  final String? myProfileImageUrl;

  /// 댓글 등록 콜백. → [PhotoCommentSheet.onSubmitComment]
  final Future<PhotoComment?> Function(String content) onSubmitComment;

  /// 댓글 목록 조회 콜백. → [PhotoCommentSheet.onLoadComments]
  final Future<List<PhotoComment>?> Function() onLoadComments;

  /// 내 댓글 수정 적용 콜백. → [PhotoCommentSheet.onEditComment]
  final Future<PhotoComment?> Function(PhotoComment comment, String newContent)
  onEditComment;

  /// 내 댓글 삭제 콜백. → [PhotoCommentSheet.onDeleteComment]
  final Future<bool> Function(PhotoComment comment) onDeleteComment;

  /// 상대 댓글 신고 콜백. → [PhotoCommentSheet.onReportComment]
  final Future<bool> Function(PhotoComment comment) onReportComment;

  /// 상대 댓글 작성자 차단 콜백. → [PhotoCommentSheet.onBlockComment]
  final Future<bool> Function(PhotoComment comment) onBlockComment;

  /// 잠긴 사진 여부. true 면 뷰어에서도 블러 + 가운데 자물쇠를 유지한다.
  /// (본인이 아직 업로드하지 않아 타인 사진이 잠긴 경우 — 댓글은 볼 수 있다)
  final bool locked;

  /// 댓글 시트를 연 채로 열지 여부. (댓글을 눌러 들어온 경우)
  /// true 면 말풍선을 거치지 않고 처음부터 시트가 올라온 상태로 시작한다.
  final bool openCommentSheet;

  /// 뷰어를 열 때 기준으로, 아직 읽지 않은 댓글이 있는지 여부.
  /// true 면 우하단 말풍선을 강조 아이콘으로 바꾼다. (카드의 댓글 버튼과 동일)
  ///
  /// 시트를 열었다 닫으면 읽은 것으로 보고 이 화면 안에서 강조를 해제한다.
  final bool commentUnread;

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
  static const _duration = PhotoCommentSheet.duration;

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

  /// 댓글 시트에 목록 재조회·키보드 내림을 요청하기 위한 키.
  final GlobalKey<PhotoCommentSheetState> _sheetKey = GlobalKey();

  /// 댓글 바텀시트 표시 여부. (닫힘 애니메이션이 끝나야 false 가 된다 —
  /// 닫기 버튼·말풍선의 Gone 상태 판단에 쓴다)
  bool _sheetVisible = false;

  /// 시트를 한 번이라도 열었는지. (닫는 순간 읽음으로 볼지 판단)
  bool _sheetOpened = false;

  /// 시트를 열었다 닫아 댓글을 읽은 것으로 본 상태.
  /// (말풍선 강조를 이 화면 안에서 해제하는 데만 쓴다 — 서버 읽음 처리는
  ///  시트가 목록을 조회하는 시점에 호출부가 따로 한다)
  bool _commentsRead = false;

  @override
  void initState() {
    super.initState();
    // 완전히 닫힌 순간에만 닫기 버튼·말풍선을 되살린다.
    // 시트를 열었다 닫은 것이므로 그 사이 댓글을 읽은 것으로 보고 강조를 해제한다.
    _sheetController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _sheetVisible = false;
          if (_sheetOpened) _commentsRead = true;
        });
      }
    });
    // 댓글을 눌러 들어왔으면 시트를 연 상태로 시작한다. 뷰어 자체가 페이드로
    // 등장하므로 시트는 애니메이션 없이 이미 올라와 있게 둔다.
    // (첫 조회는 시트가 loadOnInit 으로 알아서 한다)
    if (widget.openCommentSheet) {
      _sheetVisible = true;
      _sheetOpened = true;
      _sheetController.value = 1;
    }
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  /// 시트를 연다. (열 때마다 댓글 목록을 다시 조회한다)
  void _openSheet() {
    setState(() {
      _sheetVisible = true;
      _sheetOpened = true;
    });
    _sheetController.animateTo(1, curve: Curves.easeInOut);
    _sheetKey.currentState?.reload();
  }

  /// 시트를 닫는다. (키보드가 떠 있으면 함께 내린다)
  void _closeSheet() {
    _sheetKey.currentState?.unfocus();
    _sheetController.animateBack(0, curve: Curves.easeInOut);
  }

  /// 뷰어를 닫는다. 전송하지 못한 댓글이 남아 있으면 먼저 확인창을 띄운다.
  ///
  /// 실패한 댓글은 시트 State 에만 있어 뷰어가 pop 되면 함께 사라진다.
  /// (시트를 닫는 것만으로는 사라지지 않는다) 모르는 새 잃지 않도록 확인받는다.
  Future<void> _closeViewer() async {
    if (_sheetKey.currentState?.hasPendingComments ?? false) {
      final l10n = AppLocalizations.of(context);
      final confirmed = await AppDialog.show(
        context,
        title: l10n.commentPendingLeaveTitle,
        message: l10n.commentPendingLeaveMessage,
        // 나가면 댓글이 사라지지만, 삭제 확인창과 마찬가지로 빨간색은 쓰지 않는다.
        confirmLabel: l10n.commentPendingLeaveConfirm,
      );
      if (!confirmed) return;
    }
    if (mounted) Navigator.of(context).pop();
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
    // OS 뒤로가기(안드로이드 버튼·iOS 스와이프): 시트가 열려 있으면 시트만
    // 닫고, 닫힌 상태에서 한 번 더 하면 뷰어가 pop 된다.
    // (pop 은 항상 _closeViewer 를 거쳐야 전송 실패 댓글 확인창을 탈 수 있으므로
    // canPop 을 false 로 두고 직접 처리한다)
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _sheetVisible ? _closeSheet() : _closeViewer();
      },
      child: Stack(
        children: [
          // 빈 곳 탭 → 시트가 열려 있으면 시트만 닫고, 아니면 뷰어를 닫는다.
          // (핀치/드래그는 InteractiveViewer 가 처리)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => _sheetVisible ? _closeSheet() : _closeViewer(),
              child: AlignTransition(
                alignment: _imageAlignment,
                child: _buildImage(),
              ),
            ),
          ),
          // 우상단 닫기 버튼. (시트가 열린 동안엔 숨김)
          if (!_sheetVisible)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: CupertinoButton(
                  onPressed: _closeViewer,
                  child: const AppIcon(
                    AppIcons.close,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          // 댓글 바텀시트. (등장/퇴장·드래그는 진행도를 공유 — 이미지 도킹과 함께 움직인다)
          PhotoCommentSheet(
            key: _sheetKey,
            position: _sheetOffset,
            onDragProgress: (delta) => _sheetController.value += delta,
            onDragEnd: _onSheetDragEnd,
            title: widget.title,
            body: widget.body,
            comments: widget.comments,
            myNickname: widget.myNickname,
            myProfileImageUrl: widget.myProfileImageUrl,
            locked: widget.locked,
            loadOnInit: widget.openCommentSheet,
            onSubmitComment: widget.onSubmitComment,
            onLoadComments: widget.onLoadComments,
            onEditComment: widget.onEditComment,
            onDeleteComment: widget.onDeleteComment,
            onReportComment: widget.onReportComment,
            onBlockComment: widget.onBlockComment,
          ),
        ],
      ),
    );
  }

  /// 확대·이동 가능한 이미지와, 그 위 우하단에 고정된 댓글 말풍선.
  Widget _buildImage() {
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
              const AppIcon(
                AppIcons.lock,
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
    return Stack(
      children: [
        content,
        if (!_sheetVisible)
          Positioned(
            right: AppSpacing.s4,
            bottom: AppSpacing.s4,
            child: GestureDetector(
              onTap: _openSheet,
              child: Container(
                // 아이콘 24 + 패딩 s4(12)×2 = 지름 48 원.
                padding: const EdgeInsets.all(AppSpacing.s4),
                decoration: const BoxDecoration(
                  color: AppColors.overlayScrim,
                  shape: BoxShape.circle,
                ),
                // 읽지 않은 댓글이 있으면 점이 찍힌 말풍선으로 바꾼다.
                // (시트를 열었다 닫았으면 읽은 것으로 보고 해제)
                child: AppIcon(
                  widget.commentUnread && !_commentsRead
                      ? AppIcons.commentActive
                      : AppIcons.comment,
                  size: 24,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 이미지를 전체 화면 라이트박스로 띄운다. (검은 배경이 페이드로 나타남)
Future<void> showPhotoViewer(
  BuildContext context, {
  required ImageProvider image,
  required Future<PhotoComment?> Function(String content) onSubmitComment,
  required Future<List<PhotoComment>?> Function() onLoadComments,
  required Future<PhotoComment?> Function(
    PhotoComment comment,
    String newContent,
  )
  onEditComment,
  required Future<bool> Function(PhotoComment comment) onDeleteComment,
  required Future<bool> Function(PhotoComment comment) onReportComment,
  required Future<bool> Function(PhotoComment comment) onBlockComment,
  Object? heroTag,
  double? aspectRatio,
  String? title,
  String? body,
  List<PhotoComment> comments = const [],
  String myNickname = '',
  String? myProfileImageUrl,
  bool locked = false,
  bool openCommentSheet = false,
  bool commentUnread = false,
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
        myProfileImageUrl: myProfileImageUrl,
        locked: locked,
        openCommentSheet: openCommentSheet,
        commentUnread: commentUnread,
        onSubmitComment: onSubmitComment,
        onLoadComments: onLoadComments,
        onEditComment: onEditComment,
        onDeleteComment: onDeleteComment,
        onReportComment: onReportComment,
        onBlockComment: onBlockComment,
      ),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}
