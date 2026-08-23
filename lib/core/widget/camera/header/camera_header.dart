import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_target.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 원본사진 투명도 옵션. (왼→오 배치 순서, 값은 퍼센트)
const cameraOpacityLabels = ['0', '20', '40'];

/// 처음 선택돼 있는 투명도 옵션. (가장 진한 값)
const cameraDefaultOpacityLabel = '40';

/// 투어 타겟(라벨 + 탭) 안쪽 여백.
///
/// 강조할 때 둥근 모서리가 라벨 끝을 물지 않도록 두는 공간이다.
/// 강조 여부에 따라 크기가 변하면 구멍과 어꺋나므로 항상 적용하고,
/// 바깥 여백에서 그만큼 뺀다.
const double _targetPaddingX = AppSpacing.s3;
const double _targetPaddingY = AppSpacing.s2;

/// 투명도 변경으로 인정하는 최소 가로 스와이프 속도. (px/s)
const double _swipeVelocityThreshold = 200;

/// 가로 스와이프 속도로 [current] 다음에 선택할 투명도 라벨을 고른다.
/// 살짝 흔들린 정도이거나 더 갈 옵션이 없으면 null.
///
/// 탭 배치와 방향을 맞춘다 — 왼쪽으로 밀면 오른쪽 옵션(더 진하게),
/// 오른쪽으로 밀면 왼쪽 옵션(더 옅게)이 선택된다.
String? opacityLabelForSwipe(String current, double velocity) {
  if (velocity.abs() < _swipeVelocityThreshold) return null;

  final index = cameraOpacityLabels.indexOf(current);
  if (index < 0) return null;

  final next = index + (velocity < 0 ? 1 : -1);
  if (next < 0 || next >= cameraOpacityLabels.length) return null;
  return cameraOpacityLabels[next];
}

/// 카메라 상단 영역. '원본사진 투명도' 라벨 + 선택 탭을 둔다. (고스트 확대 모드에서만 노출)
///
/// 선택 상태는 갖지 않고 [opacityLabel] 을 그대로 그린다. 프리뷰 스와이프로도
/// 투명도가 바뀌므로 상태를 화면(부모)이 들고 있어야 두 조작이 어긋나지 않는다.
class CameraHeader extends StatelessWidget {
  const CameraHeader({
    super.key,
    this.showOpacity = false,
    this.highlightOpacity = false,
    this.opacityLabel = cameraDefaultOpacityLabel,
    required this.onOpacityChanged,
  });

  /// '원본사진 투명도' 영역(라벨 + 탭) 표시 여부.
  final bool showOpacity;

  /// 가이드 투어가 이 영역을 가리키는 중인지.
  ///
  /// true 면 배경을 깔고 라벨을 밝혀 딥 위에서도 읽힌다.
  /// (테두리는 스포트라이트가 구멍 경계에 그린다)
  final bool highlightOpacity;

  /// 현재 선택된 투명도 라벨. ([cameraOpacityLabels] 중 하나)
  final String opacityLabel;

  /// 투명도 탭이 바뀌었을 때. 선택된 라벨('0'/'20'/'40')을 전달한다.
  final ValueChanged<String> onOpacityChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 타겟 안쪽 여백을 뺀 값. 둘을 더하면 원래 여백(좌우 s5 ·
      // 상하 s4)과 같아져, 라벨 위치는 그대로다.
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s5 - _targetPaddingX,
        vertical: AppSpacing.s4 - _targetPaddingY,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 투명도 영역을 숨겨도 높이는 유지해, 모드 전환 시 헤더 높이가 변해
          // Preview 가 줄었다 늘었다 하지 않게 한다.
          Visibility(
            visible: showOpacity,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            // 라벨과 탭을 하나의 타겟으로 묶는다. 안내 문구가 '원본사진
            // 투명도' 를 가리키므로 탭만 뚚으면 무엇을 말하는지 불분명하다.
            child: CameraTourTarget(
              id: CameraTourTargets.opacityTabs,
              child: Container(
                // 여백은 강조 여부와 상관없이 항상 둔다. 강조할 때만 붙이면
                // 타겟 크기가 바뀌어, 먼저 재둔 구멍 테두리와 배경이 어꺋난다.
                padding: const EdgeInsets.symmetric(
                  horizontal: _targetPaddingX,
                  vertical: _targetPaddingY,
                ),
                decoration: highlightOpacity
                    ? ShapeDecoration(
                        color: AppColors.bgSurfaceAlt,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      )
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.s4,
                  children: [
                    AppText.label(
                      AppLocalizations.of(context).cameraOpacityLabel,
                      color: highlightOpacity ? AppColors.textPrimary : null,
                    ),
                    _OpacityTabs(
                      selectedLabel: opacityLabel,
                      onChanged: onOpacityChanged,
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
}

/// 원본사진 투명도 선택 탭. 선택값은 부모가 들고 있고, 변경 시 [onChanged] 로 알린다.
/// 선택 표시(하얀 원)는 선택된 옵션 위로 슬라이딩 이동한다.
class _OpacityTabs extends StatelessWidget {
  const _OpacityTabs({required this.selectedLabel, required this.onChanged});

  /// 현재 선택된 라벨.
  final String selectedLabel;

  final ValueChanged<String> onChanged;

  static const _labels = cameraOpacityLabels;
  static const _itemSize = 24.0;
  static const _spacing = AppSpacing.s3;
  static const _duration = Duration(milliseconds: 200);

  /// 목록에 없는 값이 들어오면 기본 선택(마지막)으로 둔다.
  int get _selectedIndex {
    final index = _labels.indexOf(selectedLabel);
    return index < 0 ? _labels.length - 1 : index;
  }

  void _select(int index) {
    if (_selectedIndex == index) return;
    onChanged(_labels[index]);
  }

  /// 옵션이 동일 크기·균등 간격이라 alignment.x 를 -1 ~ 1 로 두면
  /// thumb 가 각 옵션 중앙에 정확히 맞는다.
  Alignment get _thumbAlignment {
    if (_labels.length == 1) return Alignment.center;
    final x = _selectedIndex * 2 / (_labels.length - 1) - 1;
    return Alignment(x, 0);
  }

  @override
  Widget build(BuildContext context) {
    final width = _labels.length * _itemSize + (_labels.length - 1) * _spacing;
    final selectedIndex = _selectedIndex;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s2),
      decoration: ShapeDecoration(
        color: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      child: SizedBox(
        width: width,
        height: _itemSize,
        child: Stack(
          children: [
            // 슬라이딩 하얀 원(thumb).
            AnimatedAlign(
              duration: _duration,
              curve: Curves.easeOut,
              alignment: _thumbAlignment,
              child: Container(
                width: _itemSize,
                height: _itemSize,
                decoration: ShapeDecoration(
                  color: AppColors.bgWarm,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
            ),
            // 라벨들. (thumb 위에 얹어 글자색만 전환)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: _spacing,
              children: [
                for (var i = 0; i < _labels.length; i++)
                  _OpacityOption(
                    label: _labels[i],
                    selected: selectedIndex == i,
                    size: _itemSize,
                    duration: _duration,
                    onPressed: () => _select(i),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 투명도 탭의 단일 옵션. 배경은 thumb 가 담당하고, 여기선 글자색만 전환한다.
class _OpacityOption extends StatelessWidget {
  const _OpacityOption({
    required this.label,
    required this.selected,
    required this.size,
    required this.duration,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final double size;
  final Duration duration;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: duration,
            curve: Curves.easeOut,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              color: selected ? AppColors.bgSurface : AppColors.textPrimary,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
