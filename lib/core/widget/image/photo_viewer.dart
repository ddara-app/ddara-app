import 'dart:ui' show ImageFilter;

import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/icon/lock_icon.dart';
import 'package:ddara/core/widget/image/comment/photo_comment.dart';
import 'package:ddara/core/widget/image/comment/photo_comment_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.heroTag,
    this.aspectRatio,
    this.title,
    this.body,
    this.comments = const [],
    this.locked = false,
    this.openCommentSheet = false,
  });

  /// 크게 보여줄 이미지.
  final ImageProvider image;

  /// 바텀시트 헤더 제목. (이미지를 올린 유저 닉네임)
  final String? title;

  /// 바텀시트 헤더 본문. (해당 따라찍기 주제)
  final String? body;

  /// 댓글 시트에 표시할 댓글 목록.
  final List<PhotoComment> comments;

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
  final void Function(PhotoComment comment) onReportComment;

  /// 잠긴 사진 여부. true 면 뷰어에서도 블러 + 가운데 자물쇠를 유지한다.
  /// (본인이 아직 업로드하지 않아 타인 사진이 잠긴 경우 — 댓글은 볼 수 있다)
  final bool locked;

  /// 댓글 시트를 연 채로 열지 여부. (댓글을 눌러 들어온 경우)
  /// true 면 말풍선을 거치지 않고 처음부터 시트가 올라온 상태로 시작한다.
  final bool openCommentSheet;

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

  @override
  void initState() {
    super.initState();
    // 완전히 닫힌 순간에만 닫기 버튼·말풍선을 되살린다.
    _sheetController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() => _sheetVisible = false);
      }
    });
    // 댓글을 눌러 들어왔으면 시트를 연 상태로 시작한다. 뷰어 자체가 페이드로
    // 등장하므로 시트는 애니메이션 없이 이미 올라와 있게 둔다.
    // (첫 조회는 시트가 loadOnInit 으로 알아서 한다)
    if (widget.openCommentSheet) {
      _sheetVisible = true;
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
    setState(() => _sheetVisible = true);
    _sheetController.animateTo(1, curve: Curves.easeInOut);
    _sheetKey.currentState?.reload();
  }

  /// 시트를 닫는다. (키보드가 떠 있으면 함께 내린다)
  void _closeSheet() {
    _sheetKey.currentState?.unfocus();
    _sheetController.animateBack(0, curve: Curves.easeInOut);
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Icon(
                    CupertinoIcons.xmark,
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
            locked: widget.locked,
            loadOnInit: widget.openCommentSheet,
            onSubmitComment: widget.onSubmitComment,
            onLoadComments: widget.onLoadComments,
            onEditComment: widget.onEditComment,
            onDeleteComment: widget.onDeleteComment,
            onReportComment: widget.onReportComment,
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
              const LockIcon(size: 48, color: AppColors.textPrimary),
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
  }
}

/// 이미지를 전체 화면 라이트박스로 띄운다. (검은 배경이 페이드로 나타남)
Future<void> showPhotoViewer(
  BuildContext context, {
  required ImageProvider image,
  required Future<PhotoComment?> Function(String content) onSubmitComment,
  required Future<List<PhotoComment>?> Function() onLoadComments,
  required Future<PhotoComment?> Function(PhotoComment comment, String newContent)
  onEditComment,
  required Future<bool> Function(PhotoComment comment) onDeleteComment,
  required void Function(PhotoComment comment) onReportComment,
  Object? heroTag,
  double? aspectRatio,
  String? title,
  String? body,
  List<PhotoComment> comments = const [],
  bool locked = false,
  bool openCommentSheet = false,
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
        locked: locked,
        openCommentSheet: openCommentSheet,
        onSubmitComment: onSubmitComment,
        onLoadComments: onLoadComments,
        onEditComment: onEditComment,
        onDeleteComment: onDeleteComment,
        onReportComment: onReportComment,
      ),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}
