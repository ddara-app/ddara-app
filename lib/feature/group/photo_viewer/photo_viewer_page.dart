import 'dart:ui' show ImageFilter;

import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/button/app_text_button.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/feature/group/photo_viewer/util/photo_viewer_args.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 잠긴 사진을 가리는 블러 세기. (갤러리 카드와 같은 값)
const double _lockedBlurSigma = 12;

/// 잠긴 사진 가운데 자물쇠 아이콘 크기.
const double _lockIconSize = 48;

/// 핀치 줌 배율 범위.
const double _minScale = 1;
const double _maxScale = 4;

/// 사진 한 장을 크게 보여주는 화면.
///
/// 핀치 줌/드래그로 확대·이동할 수 있고, 상단 바에서 뒤로가거나 '꾸미기' 로
/// 넘어간다. 갤러리 카드에서 `RoutePath.photoViewer` 로 진입한다.
class PhotoViewerPage extends StatelessWidget {
  const PhotoViewerPage({super.key, required this.args});

  final PhotoViewerArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.photoViewerTitle,
        onBack: () => context.pop(),
        trailing: AppTextButton.label(
          label: l10n.photoViewerDecorate,
          onPressed: args.onDecorate,
        ),
      ),
      child: SafeArea(
        child: Padding(
          // Page 규칙의 좌우 s5. (상단 바 제목·꾸미기 버튼과 같은 선)
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
          child: Center(child: _buildImage()),
        ),
      ),
    );
  }

  /// 확대·이동 가능한 이미지.
  Widget _buildImage() {
    final ratio = args.aspectRatio;
    final rawPicture = ratio == null
        ? Image(image: args.image, fit: BoxFit.contain)
        : AspectRatio(
            aspectRatio: ratio,
            child: Image(image: args.image, fit: BoxFit.cover),
          );
    // 잠긴 사진은 갤러리 카드와 동일하게 블러 + 가운데 자물쇠를 유지한다.
    final Widget picture = args.locked
        ? Stack(
            alignment: Alignment.center,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: _lockedBlurSigma,
                  sigmaY: _lockedBlurSigma,
                ),
                child: rawPicture,
              ),
              const AppIcon(
                AppIcons.lock,
                size: _lockIconSize,
                color: AppColors.textPrimary,
              ),
            ],
          )
        : rawPicture;

    // 핀치 줌/드래그로 확대·이동.
    Widget content = InteractiveViewer(
      minScale: _minScale,
      maxScale: _maxScale,
      child: picture,
    );
    final heroTag = args.heroTag;
    if (heroTag != null) {
      content = Hero(tag: heroTag, child: content);
    }

    return content;
  }
}
