import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 미니뷰를 다시 꺼내는 것으로 인정하는 최소 오른쪽 스와이프 속도. (px/s)
/// 숨길 때([CornerMiniView])와 같은 감도로 맞춘다.
const double _showSwipeVelocity = 200;

/// 코너 미니뷰가 숨겨진 동안 프리뷰 왼쪽 가장자리에 남는 손잡이.
///
/// 가이드를 완전히 없애 버리면 다시 꺼낼 방법이 없으므로, 화면 밖으로
/// 반쯤 걸친 모양의 얇은 조각만 남긴다. 탭하거나 오른쪽으로 밀면 미니뷰가
/// 돌아온다. (밀어서 숨겼으니 미는 방향으로 되돌릴 수 있게 한다)
class CornerMiniHandle extends StatelessWidget {
  const CornerMiniHandle({super.key, required this.onShow});

  /// 미니뷰를 다시 보여 달라는 요청.
  final VoidCallback onShow;

  /// 프리뷰를 가리지 않으면서 손이 닿을 만한 높이.
  static const double _height = 88;

  /// 화면 끝에 얇게 걸치는 폭. 아이콘이 그대로 폭을 채운다.
  /// (폭을 자식에 맡기면 주변 제약에 따라 흔들려 고정한다)
  static const double _width = _iconSize;

  /// 프리뷰가 살짝 비쳐 화면에 얹힌 조각처럼 보이게 하는 불투명도.
  static const double _opacity = 0.92;

  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onShow,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Opacity(
        opacity: _opacity,
        child: Container(
          width: _width,
          height: _height,
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          decoration: const ShapeDecoration(
            color: AppColors.overlayScrim,
            // 화면 왼쪽 끝에 붙으므로 오른쪽 모서리만 둥글린다.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppRadius.xs),
                bottomRight: Radius.circular(AppRadius.xs),
              ),
            ),
          ),
          child: const AppIcon(
            AppIcons.chevronRight,
            size: _iconSize,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  /// 오른쪽(양수 속도)으로 충분히 빠르게 밀었을 때만 다시 꺼낸다.
  void _onHorizontalDragEnd(DragEndDetails details) {
    if ((details.primaryVelocity ?? 0) >= _showSwipeVelocity) onShow();
  }
}
