import 'package:ddara/core/design_system/foundation/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 디자인 시스템 공통 아이콘 위젯.
///
/// [AppIcons] 레지스트리의 아이콘을 소스(폰트/SVG) 구분 없이 동일한 API 로
/// 그린다. 브랜드 아이콘(kakao 등 멀티컬러 SVG)은 원본 색을 유지해야 하므로
/// [color] 를 넘기지 않는다.
///
/// ```dart
/// AppIcon(AppIcons.bell, size: 24, color: AppColors.textPrimary)
/// AppIcon(AppIcons.kakao, size: 20) // 브랜드 — 원본 색
/// ```
class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, {super.key, this.size = 24, this.color});

  final AppIconData icon;

  /// 한 변 크기. (정사각형)
  final double size;

  /// 틴트 색. null 이면 폰트 아이콘은 IconTheme, SVG 는 원본 색을 따른다.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color;
    return switch (icon) {
      FontIconData(icon: final data) => Icon(data, size: size, color: color),
      // Center(factor 1)로 감싸 부모가 tight 제약을 줘도 SVG 가 박스 크기로
      // 확대되지 않고 [size] 를 유지하게 한다. (폰트 Icon 과 동일한 동작)
      SvgIconData(:final assetPath) => Center(
        widthFactor: 1,
        heightFactor: 1,
        child: SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
          colorFilter: color == null
              ? null
              : ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    };
  }
}
