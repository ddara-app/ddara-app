import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

/// 아래로 갈수록 부드럽게 흐려지는 이미지(배경) 효과.
///
/// 아래엔 전체를 블러한 이미지를 깔고, 위엔 선명한 원본을 세로 그라데이션
/// 마스크로 덮어 아래로 갈수록 투명해지게 한다. 선명 이미지가 사라지는 만큼
/// 아래 블러가 비쳐, 밴드 경계 없이 선명 → 블러가 하나의 그라데이션으로 이어진다.
///
/// [BackdropFilter] 처럼 뒤의 살아있는 배경을 블러하는 게 아니라 [builder] 가
/// 그리는 이미지 자체에 블러를 적용하므로, 부드러운 알파 마스크를 쓸 수 있다.
///
/// [builder] 는 선명/블러 두 겹으로 각각 렌더링되므로 두 번 호출된다.
/// (네트워크 이미지는 캐시로 중복 요청되지 않는다.)
class ProgressiveBlurImage extends StatelessWidget {
  const ProgressiveBlurImage({
    super.key,
    required this.builder,
    this.sigma = 12,
    this.sharpUntil = 0.55,
  });

  /// 선명/블러 두 겹으로 각각 그릴 이미지(배경) 위젯 빌더.
  final WidgetBuilder builder;

  /// 하단에서 도달하는 블러 세기.
  final double sigma;

  /// 위에서부터 이 비율까지는 선명하게 두고, 이후 하단까지 서서히 블러로 전환. (0~1)
  final double sharpUntil;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 아래층: 이미지 전체를 흐리게.
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: builder(context),
        ),
        // 위층: 선명한 원본을 아래로 갈수록 투명하게.
        ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, sharpUntil, 1.0],
            colors: const [
              Color(0xFF000000),
              Color(0xFF000000),
              Color(0x00000000),
            ],
          ).createShader(rect),
          child: builder(context),
        ),
      ],
    );
  }
}