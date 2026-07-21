import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 프리뷰 보조 모드. (원본 사진을 어떻게 겹쳐 보여줄지)
enum GuideViewMode { cornerMini, ghostZoom }

/// 카메라 하단 컨트롤 영역. 모드 토글 + 촬영 버튼을 둔다.
class CameraBottom extends StatefulWidget {
  const CameraBottom({
    super.key,
    this.showViewMode = false,
    required this.onViewModeChanged,
    this.onCapture,
  });

  /// 모드 토글('코너 미니뷰'/'고스트 확대') 영역 표시 여부.
  final bool showViewMode;

  /// 모드가 바뀌었을 때 선택된 모드를 전달한다.
  final ValueChanged<GuideViewMode> onViewModeChanged;

  /// 촬영 버튼을 눌렀을 때. null 이면 아무 동작도 하지 않는다.
  final VoidCallback? onCapture;

  @override
  State<CameraBottom> createState() => _CameraBottomState();
}

class _CameraBottomState extends State<CameraBottom> {
  static const _toggleDuration = Duration(milliseconds: 250);

  GuideViewMode _mode = GuideViewMode.cornerMini;

  void _select(GuideViewMode mode) {
    if (_mode == mode) return;
    setState(() => _mode = mode);
    widget.onViewModeChanged(mode);
  }

  /// 두 버튼을 딱 붙인 묶음을 좌우로 슬라이드해, 선택된 버튼이 중앙에 오게 한다.
  /// 버튼 간격은 일정하게 유지되고 전환은 부드럽게 슬라이딩한다.
  /// - 코너 미니뷰 선택: 묶음을 오른쪽으로 → [중앙] 코너 미니뷰, [우측] 고스트 확대
  /// - 고스트 확대 선택: 묶음을 왼쪽으로 → [좌측] 코너 미니뷰, [중앙] 고스트 확대
  Widget _buildModeToggle() {
    final cornerSelected = _mode == GuideViewMode.cornerMini;

    return Align(
      alignment: Alignment.center,
      child: AnimatedSlide(
        duration: _toggleDuration,
        curve: Curves.easeInOut,
        // 묶음(두 버튼) 너비의 1/4 만큼 이동하면 선택 버튼이 중앙에 온다.
        offset: Offset(cornerSelected ? 0.25 : -0.25, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ModeButton(
              label: AppLocalizations.of(context).cameraModeCornerMini,
              selected: cornerSelected,
              onPressed: () => _select(GuideViewMode.cornerMini),
            ),
            _ModeButton(
              label: AppLocalizations.of(context).cameraModeGhostZoom,
              selected: !cornerSelected,
              onPressed: () => _select(GuideViewMode.ghostZoom),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s4,
        bottom: AppSpacing.s7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.s4,
        children: [
          // 모드 토글을 숨겨도 높이는 유지해, 하단 버튼 위치가 바뀌지 않게 한다.
          Visibility(
            visible: widget.showViewMode,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: _buildModeToggle(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_CaptureButton(onPressed: widget.onCapture ?? () {})],
          ),
          const SizedBox(height: AppSpacing.s3),
        ],
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
        padding: const EdgeInsets.all(AppSpacing.s3),
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

/// iOS 카메라 스타일 촬영 버튼. 흰색 링 안에 채워진 흰 원.
class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.onPressed});

  final VoidCallback onPressed;

  static const double _size = 72;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Container(
        width: _size,
        height: _size,
        padding: const EdgeInsets.all(AppSpacing.s1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.textPrimary, width: 4),
        ),
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
