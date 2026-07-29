import 'package:flutter/widgets.dart';

import '../../design_system/foundation/app_color_primitives.dart';
import '../../design_system/theme/app_colors.dart';

/// 사진 하단이 흐려지기 시작하는 지점. (위에서부터의 비율)
///
/// 점진 블러가 풀리기 시작하는 지점([BakedProgressiveBlurImage.sharpUntil])과
/// 스크림이 덮기 시작하는 지점을 같은 값으로 묶어, 사진 위 하단 처리를 쓰는
/// 화면(모임 카드·스타터 헤더)이 하나의 기준을 공유한다.
const double photoFadeStart = 0.6;

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

  /// 사진 위에 까는 표준 스크림. (모임 카드·스타터 헤더 공유)
  ///
  /// 점진 블러와 같은 지점([photoFadeStart])에서 시작하고, 끝을 검정 50% 로
  /// 두어 최하단에도 사진이 비친다.
  const BottomScrim.photo({super.key})
    : heightFactor = 1 - photoFadeStart,
      color = AppColorPrimitives.pureBlack,
      maxAlpha = 0.5;

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