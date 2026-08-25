import 'dart:ui' show ImageFilter;

import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 이미지를 전체 화면으로 크게 보여주는 뷰어.
///
/// 핀치 줌/드래그로 확대·이동할 수 있고, 빈 곳을 탭하거나 닫기 버튼을 누르면
/// 닫힌다. 목록 카드에서 [showPhotoViewer] 로 띄운다.
class PhotoViewer extends StatelessWidget {
  const PhotoViewer({
    super.key,
    required this.image,
    this.heroTag,
    this.aspectRatio,
    this.locked = false,
  });

  /// 크게 보여줄 이미지.
  final ImageProvider image;

  /// 잠긴 사진 여부. true 면 뷰어에서도 블러 + 가운데 자물쇠를 유지한다.
  /// (본인이 아직 업로드하지 않아 타인 사진이 잠긴 경우)
  final bool locked;

  /// 목록 카드와 뷰어를 잇는 Hero 전환 태그. null 이면 전환 애니메이션 없이 표시.
  final Object? heroTag;

  /// 카드에서 보이던 프레임 그대로 보여줄 때 쓰는 카드의 가로:세로 비율.
  /// 지정하면 이 비율의 프레임에 cover 로 잘라 담아, 카드에서 잘렸던 부분이
  /// 추가로 드러나지 않는다. null 이면 원본 전체를 보여준다. (contain)
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 빈 곳 탭 → 뷰어를 닫는다. (핀치/드래그는 InteractiveViewer 가 처리)
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(child: _buildImage()),
          ),
        ),
        // 우상단 닫기 버튼.
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: CupertinoButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const AppIcon(
                AppIcons.close,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 확대·이동 가능한 이미지.
  Widget _buildImage() {
    final ratio = aspectRatio;
    final rawPicture = ratio == null
        ? Image(image: image, fit: BoxFit.contain)
        : AspectRatio(
            aspectRatio: ratio,
            child: Image(image: image, fit: BoxFit.cover),
          );
    // 잠긴 사진은 갤러리 카드와 동일하게 블러 + 가운데 자물쇠를 유지한다.
    final Widget picture = locked
        ? Stack(
            alignment: Alignment.center,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: rawPicture,
              ),
              const AppIcon(
                AppIcons.lock,
                size: 48,
                color: AppColors.textPrimary,
              ),
            ],
          )
        : rawPicture;

    // 핀치 줌/드래그로 확대·이동.
    Widget content = InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: picture,
    );
    if (heroTag != null) {
      content = Hero(tag: heroTag!, child: content);
    }

    return content;
  }
}

/// 이미지를 전체 화면 라이트박스로 띄운다. (검은 배경이 페이드로 나타남)
Future<void> showPhotoViewer(
  BuildContext context, {
  required ImageProvider image,
  Object? heroTag,
  double? aspectRatio,
  bool locked = false,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      // 배경을 반투명하게 두어 하단 화면이 페이드로 덮이도록 한다.
      opaque: false,
      barrierColor: AppColors.bgBase,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => PhotoViewer(
        image: image,
        heroTag: heroTag,
        aspectRatio: aspectRatio,
        locked: locked,
      ),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}
