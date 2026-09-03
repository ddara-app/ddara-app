import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 미니뷰를 숨기는 것으로 인정하는 최소 왼쪽 스와이프 속도. (px/s)
/// 살짝 흔들린 정도로는 숨겨지지 않도록 투명도 스와이프와 같은 감도를 쓴다.
const double _hideSwipeVelocity = 200;

/// 미니뷰 가로 폭. 세로는 [AppRatio.photo] 로 따라 정해진다.
const double _width = 112;

/// 따라찍기 가이드(친구가 미리 찍은) 사진을 좌상단 코너에 작게 띄우는 미니뷰.
/// 표시할 이미지는 외부에서 주입한다.
///
/// 가이드가 피사체를 가리면 왼쪽으로 밀어 치울 수 있다. 숨긴 뒤 다시 꺼내는
/// 손잡이는 [CornerMiniHandle] 이 맡고, 표시 여부는 화면(부모)이 들고 있다.
class CornerMiniView extends StatelessWidget {
  const CornerMiniView({super.key, required this.image, this.onHide});

  /// 표시할 가이드 이미지.
  final ImageProvider image;

  /// 왼쪽으로 밀어 숨기려 할 때. null 이면 숨기기를 받지 않는다.
  final VoidCallback? onHide;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: onHide == null ? null : _onHorizontalDragEnd,
      child: Container(
        // 사진 프레임과 같은 비율로 고정. ([AppRatio.photo] = 가로:세로)
        width: _width,
        height: _width / AppRatio.photo,
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

  /// 왼쪽(음수 속도)으로 충분히 빠르게 밀었을 때만 숨긴다.
  void _onHorizontalDragEnd(DragEndDetails details) {
    if ((details.primaryVelocity ?? 0) <= -_hideSwipeVelocity) onHide!();
  }
}
