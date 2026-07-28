import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

/// 아래로 갈수록 블러가 점점 세지는 이미지(배경) 효과.
///
/// 선명한 원본 위에, 세기가 단계적으로 커지는 블러 레이어 [steps]장을 겹친다.
/// 각 레이어는 자기 구간에서 세로 그라데이션 마스크로 서서히 나타나므로,
/// 선명 → 약한 블러 → 강한 블러가 밴드 경계 없이 이어진다. 세기는
/// ease-in(제곱) 곡선으로 커져 시작 구간은 거의 티가 나지 않는다.
///
/// [BackdropFilter] 처럼 뒤의 살아있는 배경을 블러하는 게 아니라 [builder] 가
/// 그리는 이미지 자체에 블러를 적용하므로, 부드러운 알파 마스크를 쓸 수 있다.
///
/// [builder] 는 레이어마다 렌더링되므로 [steps] + 1 번 호출된다.
/// (네트워크 이미지는 캐시로 중복 요청되지 않는다.)
class ProgressiveBlurImage extends StatelessWidget {
  const ProgressiveBlurImage({
    super.key,
    required this.builder,
    this.sigma = 12,
    this.sharpUntil = 0.55,
    this.steps = 3,
  });

  /// 각 레이어로 그릴 이미지(배경) 위젯 빌더.
  final WidgetBuilder builder;

  /// 하단에서 도달하는 최대 블러 세기.
  final double sigma;

  /// 위에서부터 이 비율까지는 선명하게 두고, 이후 하단까지 서서히 블러로 전환. (0~1)
  final double sharpUntil;

  /// 블러 세기 단계 수. 클수록 전환이 매끄럽지만 [builder] 렌더링이 늘어난다.
  final int steps;

  @override슽
  Widget build(BuildContext context) {
    final bandWidth = (1 - sharpUntil) / steps;
    return Stack(
      fit: StackFit.expand,
      children: [
        // 맨 아래: 선명한 원본.
        builder(context),
        // 그 위로 점점 센 블러 레이어를 쌓는다. 각 레이어가 자기 구간에서
        // 페이드 인하며 아래(더 약한) 레이어를 덮는다.
        for (var step = 1; step <= steps; step++)
          _blurLayer(context, step, bandWidth),
      ],
    );
  }

  Widget _blurLayer(BuildContext context, int step, double bandWidth) {
    // ease-in(제곱) 진행: 첫 단계는 약하게 시작해 마지막 단계에 sigma 도달.
    final progress = step / steps;
    final layerSigma = sigma * progress * progress;
    final fadeStart = sharpUntil + (step - 1) * bandWidth;
    final fadeEnd = sharpUntil + step * bandWidth;

    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, fadeStart, fadeEnd, 1.0],
        colors: const [
          Color(0x00000000),
          Color(0x00000000),
          Color(0xFF000000),
          Color(0xFF000000),
        ],
      ).createShader(rect),
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: layerSigma,
          sigmaY: layerSigma,
          // 가장자리에서 알파가 빠져 아래 레이어가 비치지 않도록 clamp.
          tileMode: TileMode.clamp,
        ),
        child: builder(context),
      ),
    );
  }
}
