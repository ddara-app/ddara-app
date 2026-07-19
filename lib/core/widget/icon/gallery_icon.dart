import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 공통 갤러리(이미지) 아이콘. (`assets/images/ic_image.svg` 를 [size]·[color] 로 그린다)
///
/// 아이콘 SVG 는 고정 색으로 되어 있어 [color] 로 틴트해 그린다.
class GalleryIcon extends StatelessWidget {
  const GalleryIcon({super.key, required this.size, required this.color});

  /// 아이콘 한 변의 크기. (정사각)
  final double size;

  /// 아이콘 색.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/ic_image.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
