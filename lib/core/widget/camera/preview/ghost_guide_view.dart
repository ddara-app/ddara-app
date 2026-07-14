import 'package:ddara/core/designsystem/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 고스트 확대 모드에서 가이드(친구가 미리 찍은) 사진을 크게 반투명으로 겹쳐 보여주는 뷰.
/// 표시할 이미지는 외부에서 주입하고, 투명도는 [opacity] 로 조절한다.
///
/// 프리뷰 전체 크기를 받아 가운데 [windowFactor] 비율의 창만 남긴다.
/// 이미지는 [frameAspectRatio] 프레임(모임 상세 헤더에서 보이던 크롭)으로 먼저
/// 잘라 프리뷰 전체 크기에 맞춰 그리고, 창 밖으로 넘치는 부분은 잘린다.
class GhostGuideView extends StatelessWidget {
  const GhostGuideView({
    super.key,
    required this.image,
    this.opacity = 0.4,
    this.windowFactor = 0.9,
    this.frameAspectRatio,
  });

  /// 표시할 가이드 이미지.
  final ImageProvider image;

  /// 0.0(투명) ~ 1.0(불투명) 사이의 표시 투명도.
  final double opacity;

  /// 프리뷰 대비 창(보이는 영역)의 비율.
  final double windowFactor;

  /// 이미지를 먼저 잘라낼 기준 프레임의 가로:세로 비율.
  /// (원본 전체가 아니라 이 프레임에 보이던 부분만 가이드로 쓴다)
  /// null 이면 프레임 크롭 없이 프리뷰 비율로 바로 자른다.
  final double? frameAspectRatio;

  @override
  Widget build(BuildContext context) {
    final frameRatio = frameAspectRatio;
    // 프리뷰 전체를 채울 그림. 기준 프레임 비율로 먼저 크롭한 뒤 프리뷰 크기로
    // 확대한다. (SizedBox 의 숫자는 비율만 의미 — FittedBox 가 확대한다)
    final Widget picture = frameRatio == null
        ? Image(image: image, fit: BoxFit.cover)
        : FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: frameRatio * 100,
              height: 100,
              child: Image(image: image, fit: BoxFit.cover),
            ),
          );

    return Opacity(
      opacity: opacity,
      child: FractionallySizedBox(
        widthFactor: windowFactor,
        heightFactor: windowFactor,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: AppColors.borderStrong),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 창 크기를 프리뷰 전체 크기로 되돌린 값.
              final previewWidth = constraints.maxWidth / windowFactor;
              final previewHeight = constraints.maxHeight / windowFactor;
              return OverflowBox(
                maxWidth: previewWidth,
                maxHeight: previewHeight,
                // 그림 박스를 프리뷰 크기로 고정해 프리뷰에 채웠을 때와 같은
                // 배율로 그리고, 창 밖으로 넘치는 부분은 위 Container 가
                // 잘라낸다. (창이 90% 이므로 상하좌우 5%씩 더 잘려 보인다)
                child: SizedBox(
                  width: previewWidth,
                  height: previewHeight,
                  child: picture,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
