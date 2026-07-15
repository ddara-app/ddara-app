import 'package:ddara/core/designsystem/design_system.dart';
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
      width: 96,
      height: 128,
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
