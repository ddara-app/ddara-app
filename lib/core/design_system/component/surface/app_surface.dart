import 'package:flutter/cupertino.dart';

import '../../foundation/app_radius.dart';
import '../../theme/app_colors.dart';

/// 둥근 모서리 + 채워진 배경을 가진 공통 표면(surface) 컴포넌트.
///
/// 프로필 섹션, 약관 동의 목록, 권한 항목 등에서 쓰는 "둥근 카드 배경"을
/// 하나로 모은 컴포넌트다. 기본값은 [AppColors.bgSurface] 배경 + [AppRadius.md]
/// 반경이며, 필요에 따라 [color] · [radius] · [padding] 을 덮어쓸 수 있다.
///
/// (고유한 내용을 담는 콘텐츠 "Card" 위젯들과 구분되도록, 내용 없는 배경
/// 역할임을 드러내는 surface 라는 이름을 쓴다.)
///
/// [onTap] 을 주면 표면 전체가 탭에 반응하고, [pressedColor] 를 함께 주면
/// 누르는 동안 그 색으로 살짝 바뀐다. (예: 권한 항목)
class AppSurface extends StatefulWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.color = AppColors.bgSurface,
    this.pressedColor,
    this.radius = AppRadius.md,
    this.padding,
    this.onTap,
  });

  /// 표면 안에 들어갈 위젯.
  final Widget child;

  /// 배경색.
  final Color color;

  /// 누르는 동안의 배경색. null 이면 누름 효과 없음. ([onTap] 과 함께 쓴다)
  final Color? pressedColor;

  /// 모서리 반경.
  final double radius;

  /// 내부 패딩. null 이면 패딩 없음.
  final EdgeInsetsGeometry? padding;

  /// 표면을 눌렀을 때 실행할 콜백. null 이면 탭에 반응하지 않는다.
  final VoidCallback? onTap;

  @override
  State<AppSurface> createState() => _AppSurfaceState();
}

class _AppSurfaceState extends State<AppSurface> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final bg = _pressed && widget.pressedColor != null
        ? widget.pressedColor!
        : widget.color;

    final surface = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: double.infinity,
      padding: widget.padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: widget.child,
    );

    if (widget.onTap == null) return surface;

    return GestureDetector(
      // 표면 전체 영역이 탭에 반응하도록
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: surface,
    );
  }
}
