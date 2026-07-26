import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 컨텍스트 메뉴 항목 하나. (라벨 + 글자색 + 선택 콜백)
/// [color] 가 null 이면 본문 기본색으로 그린다.
typedef MenuAction = ({String label, Color? color, VoidCallback onSelect});

/// 메뉴가 대상 기준 어디에 붙는지.
enum ContextMenuPlacement {
  /// 대상 바로 위. 좌우 가장자리를 맞춘다. (사진 카드 등)
  above,

  /// 대상의 대각선 위. 대상을 가리지 않는다. (아바타처럼 작은 대상)
  aboveDiagonal,

  /// 대상 안쪽 좌상단. (화면 상단에 붙어 위쪽 공간이 없는 큰 헤더)
  insideTopLeft,
}

/// 길게 눌러 대상에 붙은 컨텍스트 메뉴를 띄우는 래퍼.
///
/// 메뉴가 열리면 배경을 어둡게 덮고, 대상 사본을 스크림 위로 띄워 선명하게
/// 유지한다. 바깥을 탭하거나 뒤로가기(Android)하면 닫힌다.
///
/// [above]·[aboveDiagonal] 은 대상이 화면 오른쪽에 있으면 좌우를 뒤집어
/// 메뉴가 화면 밖으로 잘리지 않게 한다.
class AnchoredContextMenu extends StatefulWidget {
  const AnchoredContextMenu({
    super.key,
    required this.child,
    required this.actions,
    this.overlayBuilder,
    this.placement = ContextMenuPlacement.above,
  });

  /// 길게 누를 대상.
  final Widget child;

  /// 메뉴에 나열할 항목들. (위에서부터 순서대로)
  final List<MenuAction> actions;

  /// 스크림 위로 띄울 대상 사본. null 이면 [child] 를 그대로 띄운다.
  ///
  /// 오버레이에는 원본이 받던 레이아웃 제약이 없으므로 대상의 실제 크기를
  /// 함께 넘긴다. (Hero 태그가 붙은 대상은 태그 없는 사본을 만들어야 한다)
  final Widget Function(BuildContext context, Size targetSize)? overlayBuilder;

  /// 메뉴를 붙일 위치.
  final ContextMenuPlacement placement;

  @override
  State<AnchoredContextMenu> createState() => _AnchoredContextMenuState();
}

class _AnchoredContextMenuState extends State<AnchoredContextMenu> {
  /// 대상 위치를 메뉴·사본이 따라가게 잇는 링크.
  final LayerLink _link = LayerLink();

  /// 열려 있는 메뉴 라우트. 닫혀 있으면 null.
  Route<void>? _menuRoute;

  /// 오버레이에 띄울 사본 크기. (메뉴를 열 때 측정)
  Size? _targetSize;

  /// 메뉴를 대상 오른쪽 끝에 맞춰 열지 여부. (메뉴를 열 때 결정)
  bool _alignRight = false;

  void _open() {
    if (_menuRoute != null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      // 사본이 원본과 정확히 겹치도록 현재 크기를 기억해 둔다.
      _targetSize = box.size;
      // 열기 직전 위치로 펼침 방향을 정한다. (스크롤로 위치가 바뀌므로 매번 계산)
      final center = box.localToGlobal(Offset.zero).dx + box.size.width / 2;
      _alignRight = center > MediaQuery.sizeOf(context).width / 2;
    }

    // 메뉴를 라우트로 띄워 뒤로가기(Android)가 화면 pop 대신 메뉴 닫기가
    // 되도록 한다. (스크림·바깥 탭 닫기는 라우트 배리어가 처리)
    final route = RawDialogRoute<void>(
      barrierColor: AppColorPrimitives.black60,
      barrierLabel: AppLocalizations.of(context).commonCancel,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, _) => _buildOverlay(dialogContext),
    );
    _menuRoute = route;
    Navigator.of(context).push(route).then((_) => _menuRoute = null);
  }

  /// 메뉴를 닫은 뒤 선택한 항목의 콜백을 실행한다.
  void _select(BuildContext dialogContext, VoidCallback onSelect) {
    Navigator.of(dialogContext).pop();
    onSelect();
  }

  @override
  void dispose() {
    // 대상이 사라지면(목록 갱신·화면 전환 등) 열려 있던 메뉴도 함께 닫는다.
    final route = _menuRoute;
    if (route != null && route.isActive) {
      route.navigator?.removeRoute(route);
    }
    super.dispose();
  }

  /// 대상을 기준으로 메뉴가 붙는 지점. ([targetAnchor], [followerAnchor], [offset])
  ({Alignment target, Alignment follower, Offset offset}) get _anchor {
    switch (widget.placement) {
      case ContextMenuPlacement.above:
        return (
          target: _alignRight ? Alignment.topRight : Alignment.topLeft,
          follower: _alignRight ? Alignment.bottomRight : Alignment.bottomLeft,
          offset: const Offset(0, -AppSpacing.s2),
        );
      case ContextMenuPlacement.aboveDiagonal:
        // 대상 모서리에 메뉴 모서리를 s1 만큼 겹쳐 대각선으로 붙인다.
        return (
          target: _alignRight ? Alignment.topLeft : Alignment.topRight,
          follower: _alignRight ? Alignment.bottomRight : Alignment.bottomLeft,
          offset: Offset(
            _alignRight ? AppSpacing.s1 : -AppSpacing.s1,
            AppSpacing.s1,
          ),
        );
      case ContextMenuPlacement.insideTopLeft:
        return (
          target: Alignment.topLeft,
          follower: Alignment.topLeft,
          offset: const Offset(AppSpacing.s3, AppSpacing.s3),
        );
    }
  }

  Widget _buildOverlay(BuildContext dialogContext) {
    final targetSize = _targetSize;
    final overlayBuilder = widget.overlayBuilder;
    final anchor = _anchor;

    return Stack(
      children: [
        // 대상 사본을 스크림 위로 띄워 선명하게 유지한다.
        // (원본 위에 정확히 겹쳐 대상만 떠오른 것처럼 보인다)
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.topLeft,
          child: IgnorePointer(
            child: overlayBuilder == null || targetSize == null
                ? widget.child
                : overlayBuilder(dialogContext, targetSize),
          ),
        ),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: anchor.target,
          followerAnchor: anchor.follower,
          offset: anchor.offset,
          child: _menu(dialogContext),
        ),
      ],
    );
  }

  Widget _menu(BuildContext dialogContext) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: const [
          BoxShadow(
            color: AppColorPrimitives.black40,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      // 항목들의 폭을 가장 긴 라벨에 맞춰 통일한다.
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < widget.actions.length; i++) ...[
              if (i > 0) Container(height: 1, color: AppColors.borderDefault),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                  vertical: AppSpacing.s3,
                ),
                minimumSize: Size.zero,
                onPressed: () =>
                    _select(dialogContext, widget.actions[i].onSelect),
                child: AppText.body(
                  widget.actions[i].label,
                  color: widget.actions[i].color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(onLongPress: _open, child: widget.child),
    );
  }
}
