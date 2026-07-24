import 'package:flutter/widgets.dart';

import '../../design_system/theme/app_colors.dart';

/// 카드·이미지 하단을 어둡게 덮는 그라데이션 스크림.
///
/// 위는 투명, 아래로 갈수록 [color] 로 짙어져(끝은 불투명) 하단 텍스트의
/// 가독성을 확보하고, 끝 색을 배경색([AppColors.bgBase])과 맞추면 카드 하단
/// 경계가 배경과 자연스럽게 이어진다.
///
/// [Stack] 안에 그대로 넣어 쓴다. (자체적으로 [Positioned.fill] · [IgnorePointer]
/// 를 포함하므로 탭 이벤트를 가로채지 않는다.)
///
/// ```dart
/// Stack(children: [image, const BottomScrim(), bottomText])
/// ```
class BottomScrim extends StatelessWidget {
  const BottomScrim({
    super.key,
    this.heightFactor = 0.4,
    this.color = AppColors.bgBase,
    this.maxAlpha = 1.0,
  });

  /// 스크림이 덮는 높이 비율. (부모 높이의 0~1)
  final double heightFactor;

  /// 그라데이션 색. 아래로 갈수록 이 색으로 짙어진다.
  final Color color;

  /// 그라데이션이 도달하는 최대 불투명도. (0~1, 기본 1.0 = 불투명)
  final double maxAlpha;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: heightFactor,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // 시작 구간을 ease-in(제곱 곡선)으로 촘촘히 샘플링해, 스크림
                  // 상단 경계에서 기울기가 0으로 출발한다 — 경계 띠(Mach band)가
                  // 보이지 않고 자연스럽게 스며든다. (0.55 지점 0.38 을 지나
                  // 하단에서 maxAlpha 도달)
                  stops: const [0.0, 0.15, 0.3, 0.45, 0.55, 1.0],
                  colors: [
                    color.withValues(alpha: 0),
                    color.withValues(alpha: 0.03 * maxAlpha),
                    color.withValues(alpha: 0.11 * maxAlpha),
                    color.withValues(alpha: 0.25 * maxAlpha),
                    color.withValues(alpha: 0.38 * maxAlpha),
                    color.withValues(alpha: maxAlpha),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}