import 'package:ddara/core/designsystem/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 썸네일이 없거나 로드 실패했을 때의 자리표시. (빈 배경 + 중앙 갤러리 아이콘)
///
/// 부모 제약을 채우므로 [Positioned.fill] 이나 고정 크기 컨테이너 안에서 쓴다.
class EmptyThumbnail extends StatelessWidget {
  const EmptyThumbnail({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.bgSurfaceAlt,
      child: Center(
        child: Icon(
          CupertinoIcons.photo,
          size: 40,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
