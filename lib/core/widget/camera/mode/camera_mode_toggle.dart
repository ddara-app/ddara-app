import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_target.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 프리뷰 보조 모드. (원본 사진을 어떻게 겹쳐 보여줄지)
enum GuideViewMode { cornerMini, ghostZoom }

/// 모드 전환으로 인정하는 최소 가로 스와이프 속도. (px/s)
const double _swipeVelocityThreshold = 200;

/// 가로 스와이프 속도로 전환할 모드를 고른다. 살짝 흔들린 정도면 null.
///
/// 토글 버튼 배치와 방향을 맞춘다 — 왼쪽으로 밀면 오른쪽 항목(고스트 확대),
/// 오른쪽으로 밀면 왼쪽 항목(코너 미니뷰)이 선택된다.
GuideViewMode? _guideModeForSwipe(double velocity) {
  if (velocity.abs() < _swipeVelocityThreshold) return null;
  return velocity < 0 ? GuideViewMode.ghostZoom : GuideViewMode.cornerMini;
}

/// 프리뷰 바로 아래에 붙는 모드 토글. ('코너 미니뷰' / '고스트 확대')
///
/// 선택 상태는 갖지 않고 [mode] 를 그대로 그린다. 모드에 따라 헤더의 투명도
/// 영역도 함께 바뀌므로 상태를 화면(부모)이 들고 있어야 한다.
/// [visible] 이 false 여도 높이는 유지해, 모드 전환으로 프리뷰가 줄었다
/// 늘었다 하지 않게 한다.
class CameraModeToggle extends StatelessWidget {
  const CameraModeToggle({
    super.key,
    this.visible = false,
    required this.mode,
    required this.onChanged,
  });

  /// 토글 표시 여부. (false 면 자리만 차지한다)
  final bool visible;

  /// 현재 선택된 모드.
  final GuideViewMode mode;

  /// 모드가 바뀌었을 때 선택된 모드를 전달한다.
  final ValueChanged<GuideViewMode> onChanged;

  static const _duration = Duration(milliseconds: 250);

  void _select(GuideViewMode next) {
    if (mode == next) return;
    onChanged(next);
  }

  /// 토글 위에서의 가로 스와이프.
  void _onHorizontalDragEnd(DragEndDetails details) {
    final next = _guideModeForSwipe(details.primaryVelocity ?? 0);
    if (next != null) _select(next);
  }

  /// 두 버튼을 딱 붙인 묶음을 좌우로 슬라이드해, 선택된 버튼이 중앙에 오게 한다.
  /// 버튼 간격은 일정하게 유지되고 전환은 부드럽게 슬라이딩한다.
  /// - 코너 미니뷰 선택: 묶음을 오른쪽으로 → [중앙] 코너 미니뷰, [우측] 고스트 확대
  /// - 고스트 확대 선택: 묶음을 왼쪽으로 → [좌측] 코너 미니뷰, [중앙] 고스트 확대
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cornerSelected = mode == GuideViewMode.cornerMini;

    return Visibility(
      visible: visible,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      // 버튼 밖 빈 자리에서도 스와이프가 먹도록 줄 전체에서 제스처를 받는다.
      // (버튼 탭은 제스처 아레나에서 탭이 우선되어 그대로 동작한다)
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Align(
          alignment: Alignment.center,
          child: AnimatedSlide(
            duration: _duration,
            curve: Curves.easeInOut,
            // 묶음(두 버튼) 너비의 1/4 만큼 이동하면 선택 버튼이 중앙에 온다.
            offset: Offset(cornerSelected ? 0.25 : -0.25, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ModeButton(
                  label: l10n.cameraModeCornerMini,
                  selected: cornerSelected,
                  onPressed: () => _select(GuideViewMode.cornerMini),
                ),
                // 가이드 투어는 이 버튼 하나만 하이라이트한다.
                // (묶음이나 바깥 GestureDetector 를 감싸면 구멍이 안내하려는
                //  기능보다 훨씬 넓게 뚫린다)
                CameraTourTarget(
                  id: CameraTourTargets.ghostZoomMode,
                  child: _ModeButton(
                    label: l10n.cameraModeGhostZoom,
                    selected: !cornerSelected,
                    onPressed: () => _select(GuideViewMode.ghostZoom),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 프리뷰 모드 선택용 텍스트 버튼.
/// 선택 시 글자색이 강조색(AppButton 배경색)으로 부드럽게 페이드된다.
class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  static const _duration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: AnimatedDefaultTextStyle(
          duration: _duration,
          curve: Curves.easeInOut,
          style: AppTypography.label.copyWith(
            color: selected ? AppColors.accentDefault : AppColors.textTertiary,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
