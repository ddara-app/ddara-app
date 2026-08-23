import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_controller.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_step.dart';
import 'package:ddara/core/widget/camera/tour/widget/camera_tour_tooltip.dart';
import 'package:ddara/core/widget/camera/tour/widget/hole_hit_test.dart';
import 'package:ddara/core/widget/camera/tour/widget/spotlight_painter.dart';
import 'package:flutter/widgets.dart';

/// 구멍이 다음 자리로 옮겨 가는 시간.
/// 코너 미니뷰 ↔ 손잡이 전환(`AnimatedSwitcher` 200ms)과 맞춰, 접기 시연에서
/// 구멍이 화면과 함께 움직이게 한다.
const Duration _moveDuration = Duration(milliseconds: 200);

/// 구멍 이동 곡선. 위와 같은 이유로 `AnimatedSwitcher` 의 것과 맞춘다.
const Curve _moveCurve = Curves.easeOut;

/// 구멍과 툴팁 사이 간격.
const double _tooltipGap = AppSpacing.s4;

/// 말풍선 최대 폭. 실제 폭은 문구 길이가 정하고 이 값을 넘지만 않는다.
const double _tooltipMaxWidth = 320;

/// 구멍 오른쪽에 놓을 때 이만큼도 안 남으면 위/아래 배치로 되돌린다.
/// (문구 길이를 재기 전이라 배치 판단은 이 어림값으로 한다)
const double _tooltipMinWidth = 160;

/// 이만큼도 안 남으면 툴팁을 반대편으로 넘긴다.
const double _tooltipMinHeight = 140;

/// 딤 + 구멍 + 안내 말풍선을 그리는 투어 오버레이.
///
/// 화면 좌표계를 그대로 쓰므로 화면 전체를 덮는 자리에 놓아야 한다.
/// (`SafeArea` 안쪽에 두면 구멍 위치가 어긋난다)
class CameraTourOverlay extends StatefulWidget {
  const CameraTourOverlay({super.key, required this.controller});

  final CameraTourController controller;

  @override
  State<CameraTourOverlay> createState() => _CameraTourOverlayState();
}

class _CameraTourOverlayState extends State<CameraTourOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: _moveDuration,
  );

  /// 보간에 쓰는 진행도. (곡선을 입힌 [_animation])
  late final CurvedAnimation _progress = CurvedAnimation(
    parent: _animation,
    curve: _moveCurve,
  );

  /// 전환 시작 지점. (직전 스텝의 구멍·딤)
  Rect? _fromHole;
  double _fromDim = CameraTourStep.defaultDim;

  /// 전환 도착 지점. (현재 스텝의 구멍·딤)
  Rect? _toHole;
  double _toDim = CameraTourStep.defaultDim;

  @override
  void initState() {
    super.initState();
    _toHole = widget.controller.hole;
    _toDim = _currentStepDim();
    _animation.value = 1;
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _progress.dispose();
    _animation.dispose();
    super.dispose();
  }

  double _currentStepDim() {
    final controller = widget.controller;
    return controller.isActive ? controller.current.dim : _toDim;
  }

  /// 목표 구멍이 바뀌면 현재 그려진 위치에서 새 위치로 이어 붙인다.
  void _onControllerChanged() {
    final nextHole = widget.controller.hole;
    final nextDim = _currentStepDim();
    if (nextHole == _toHole && nextDim == _toDim) return;

    setState(() {
      _fromHole = _lerpedHole();
      _fromDim = _lerpedDim();
      _toHole = nextHole;
      _toDim = nextDim;
    });

    if (MediaQuery.disableAnimationsOf(context)) {
      _animation.value = 1;
    } else {
      _animation.forward(from: 0);
    }
  }

  /// 현재 프레임에 그릴 구멍. 한쪽이 없으면 보간하지 않는다.
  /// (없는 쪽을 0 크기로 다루면 화면 좌상단에서 튀어나오는 것처럼 보인다)
  Rect? _lerpedHole() {
    final from = _fromHole;
    final to = _toHole;
    if (from == null || to == null) return to;
    return Rect.lerp(from, to, _progress.value);
  }

  double _lerpedDim() => lerpDouble(_fromDim, _toDim, _progress.value)!;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    if (!controller.isActive) return const SizedBox.shrink();

    final step = controller.current;

    return PopScope(
      // 투어 중 뒤로가기는 화면이 아니라 투어를 먼저 닫는다.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        controller.skip();
      },
      // 구멍 좌표는 이 오버레이가 덮는 상자 기준이므로, 화면 크기가 아니라
      // 실제로 받은 제약을 툴팁 배치에 쓴다. (오버레이는 AppBar 아래에서 시작)
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              final hole = _lerpedHole();

              return HoleHitTest(
                hole: hole,
                passThrough: step.allowTouch,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // 딤 아무 곳이나 탭하면 다음으로 넘어간다.
                  onTap: controller.next,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: SpotlightPainter(
                            hole: hole,
                            // 접기 시연에서는 가리키는 대상이 바뀌므로
                            // 스텝 값이 아니라 컨트롤러가 정한 값을 쓴다.
                            radius: controller.holeRadius,
                            dim: _lerpedDim(),
                            shape: step.shape,
                          ),
                        ),
                      ),
                      _tooltip(context, step, hole, constraints.biggest),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 스텝이 정한 자리에 툴팁을 놓는다.
  ///
  /// 위/아래는 그쪽 공간이 모자라면 반대편으로 넘기고, 좌우는 구멍 중심에
  /// 맞추되 화면 안으로 밀어 넣는다. 오른쪽 배치는 구멍이 화면 한쪽에 치우쳐
  /// 있을 때 쓰며, 남는 폭이 모자라면 아래 배치로 되돌린다.
  ///
  /// [area] 는 오버레이가 덮는 상자의 크기다. 구멍 좌표와 같은 기준이라야
  /// 툴팁이 구멍에 붙는다.
  Widget _tooltip(
    BuildContext context,
    CameraTourStep step,
    Rect? hole,
    Size area,
  ) {
    final controller = widget.controller;
    // 오버레이 위쪽은 AppBar 가 이미 소비했으므로 아래 여백만 고려한다.
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // 구멍 오른쪽에 놓을 수 있는지 먼저 본다. (폭이 모자라면 아래로 되돌린다)
    final spaceRight = hole == null
        ? 0.0
        : area.width - hole.right - _tooltipGap - AppSpacing.s5;
    final placeRight =
        hole != null &&
        step.placement == CameraTourPlacement.right &&
        spaceRight >= _tooltipMinWidth;

    // 폭을 고정하지 않고 상한만 준다. 실제 폭은 문구가 정한다.
    final maxWidth = math.min(
      _tooltipMaxWidth,
      placeRight ? spaceRight : area.width - AppSpacing.s5 * 2,
    );
    final content = CameraTourTooltip(
      step: step,
      stepNumber: controller.stepNumber,
      stepCount: controller.stepCount,
      isLastStep: controller.isLastStep,
      canGoBack: controller.canGoBack,
      onNext: controller.next,
      onPrevious: controller.previous,
    );
    final tooltip = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: content,
    );

    // 구멍이 없는 스텝은 화면 가운데에 띄운다.
    if (hole == null) return Center(child: tooltip);

    // 구멍 오른쪽에 붙이고 위쪽을 구멍에 맞춘다.
    if (placeRight) {
      return Positioned(
        left: hole.right + _tooltipGap,
        top: hole.top,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: math.max(
              _tooltipMinHeight,
              area.height - bottomInset - hole.top,
            ),
          ),
          child: tooltip,
        ),
      );
    }

    final spaceAbove = hole.top - _tooltipGap;
    final spaceBelow = area.height - bottomInset - hole.bottom - _tooltipGap;

    var placeAbove = step.placement == CameraTourPlacement.top;
    if (placeAbove && spaceAbove < _tooltipMinHeight) {
      placeAbove = spaceBelow <= spaceAbove;
    } else if (!placeAbove && spaceBelow < _tooltipMinHeight) {
      placeAbove = spaceAbove > spaceBelow;
    }

    final maxHeight = math.max(
      _tooltipMinHeight,
      placeAbove ? spaceAbove : spaceBelow,
    );

    // 폭을 미리 알 수 없으므로(문구 길이가 정한다) 좌표 대신 비율로 맞춘다.
    // 구멍이 가운데면 말풍선도 가운데, 가장자리면 그쪽 끝으로 붙고,
    // 그 사이는 부드럽게 이어진다. (화면 밖으로 나가지 않는다)
    final alignX = area.width == 0
        ? 0.0
        : (hole.center.dx / area.width * 2 - 1).clamp(-1.0, 1.0).toDouble();

    return Positioned(
      left: 0,
      right: 0,
      top: placeAbove ? null : hole.bottom + _tooltipGap,
      bottom: placeAbove ? area.height - hole.top + _tooltipGap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
        child: Align(
          alignment: Alignment(alignX, 0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: tooltip,
          ),
        ),
      ),
    );
  }
}
