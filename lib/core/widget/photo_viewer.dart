import 'package:ddara/core/designsystem/design_system.dart';
import 'package:flutter/cupertino.dart';

/// 이미지를 전체 화면으로 크게 보여주는 뷰어.
///
/// 핀치 줌/드래그로 확대·이동할 수 있고, 빈 곳을 탭하거나 닫기 버튼을 누르면
/// 닫힌다. 목록 카드에서 [showPhotoViewer] 로 띄운다.
class PhotoViewer extends StatelessWidget {
  const PhotoViewer({super.key, required this.image, this.heroTag});

  /// 크게 보여줄 이미지.
  final ImageProvider image;

  /// 목록 카드와 뷰어를 잇는 Hero 전환 태그. null 이면 전환 애니메이션 없이 표시.
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    // 핀치 줌/드래그로 확대·이동. (원본 비율 유지)
    Widget content = InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: Image(image: image, fit: BoxFit.contain),
    );
    if (heroTag != null) {
      content = Hero(tag: heroTag!, child: content);
    }

    return Stack(
      children: [
        // 빈 곳을 탭하면 닫힌다. (핀치/드래그는 InteractiveViewer 가 처리)
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(child: content),
          ),
        ),
        // 우상단 닫기 버튼.
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: CupertinoButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(
                CupertinoIcons.xmark,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 이미지를 전체 화면 라이트박스로 띄운다. (검은 배경이 페이드로 나타남)
Future<void> showPhotoViewer(
  BuildContext context, {
  required ImageProvider image,
  Object? heroTag,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      // 배경을 반투명하게 두어 하단 화면이 페이드로 덮이도록 한다.
      opaque: false,
      barrierColor: AppColors.bgBase,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => PhotoViewer(image: image, heroTag: heroTag),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}