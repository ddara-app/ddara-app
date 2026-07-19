import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 따라찍기 가이드(친구가 미리 찍은) 사진을 좌상단 코너에 작게 띄우는 미니뷰.
/// 표시할 이미지는 외부에서 주입한다.
class CornerMiniView extends StatelessWidget {
  const CornerMiniView({super.key, required this.image});

  /// 표시할 가이드 이미지.
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 3:4 비율 고정.
      width: 112,
      height: 112 * 4 / 3,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        image: DecorationImage(image: image, fit: BoxFit.cover),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: AppColors.borderStrong),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }
}
