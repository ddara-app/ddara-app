import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 원형 프로필 아바타.
///
/// [imageUrl] 이 있으면 네트워크 이미지를 [size] 지름의 원 안에 보여주고,
/// 없거나 로드 실패하면 자체 원형 형태를 가진 기본 프로필 아이콘을 보여준다.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.size, this.imageUrl});

  /// 아바타 원 지름.
  final double size;

  /// 프로필 이미지 URL. null·빈 값이면 기본 아이콘을 보여준다.
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final hasImage = url != null && url.isNotEmpty;

    // 기본 아이콘은 자체적으로 원형 형태를 가지므로 Container 로 감싸지 않는다.
    // (감싸면 배경이 중복된다)
    if (!hasImage) return _DefaultIcon(size: size);

    // 테두리를 두면 자식이 그만큼 안쪽으로 밀려 상하좌우에 배경색이 비치므로
    // (border-deflation) 테두리 없이 이미지가 원 전체를 채우게 한다.
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.bgSurfaceAlt,
        shape: BoxShape.circle,
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        // 표시 지름(물리 픽셀)에 맞춰 디코딩해 작은 아바타의 메모리 사용을 줄인다.
        memCacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
        // 로딩 중·로드 실패 모두 기본 아이콘으로 대체.
        placeholder: (context, url) => _DefaultIcon(size: size),
        errorWidget: (context, url, error) => _DefaultIcon(size: size),
      ),
    );
  }
}

/// 이미지가 없거나 로드 실패했을 때의 기본 프로필 아이콘.
/// 자체적으로 원형 형태를 가지므로 [size] 지름을 그대로 채운다.
class _DefaultIcon extends StatelessWidget {
  const _DefaultIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/ic_person_circle_fill.svg',
      width: size,
      height: size,
    );
  }
}
