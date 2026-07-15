import 'package:ddara/core/designsystem/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 고스트 확대 모드에서 가이드(친구가 미리 찍은) 사진을 크게 반투명으로 겹쳐 보여주는 뷰.
/// 표시할 이미지는 외부에서 주입하고, 투명도는 [opacity] 로 조절한다.
class GhostGuideView extends StatelessWidget {
  const GhostGuideView({super.key, required this.image, this.opacity = 0.4});

  /// 표시할 가이드 이미지.
  final ImageProvider image;

  /// 0.0(투명) ~ 1.0(불투명) 사이의 표시 투명도.
  final double opacity;

  @override
  Widget build(BuildContext context) {
    // 크기는 부모(상위에서 Preview 영역 비율로 제약)를 따른다.
    return Opacity(
      opacity: opacity,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          image: DecorationImage(image: image, fit: BoxFit.cover),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: AppColors.borderStrong),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
    );
  }
}
