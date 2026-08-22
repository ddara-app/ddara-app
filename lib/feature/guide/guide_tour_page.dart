import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/widget/camera/camera.dart';
import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 카메라 프리뷰 자리를 대신할 사진. (따라찍는 사람이 보게 될 화면)
/// 원본이 870x1160 = 3:4 라 사진 프레임(AppRatio.photo)에 그대로 들어맞는다.
const String _previewImagePath = 'assets/images/follower_card.png';

/// 미니뷰·고스트로 겹쳐 보일 가이드 사진. (스타터가 먼저 올린 원본)
const String _guideImagePath = 'assets/images/stater_card.png';

/// 가이드 화면에서 여는 촬영 안내 시연.
///
/// 실제 카메라를 켜지 않고 정적 이미지 위에 코치마크만 얹는다. 안내를 끝까지
/// 보면('시작하기') 가이드 화면으로 돌아간다.
class GuideTourPage extends StatelessWidget {
  const GuideTourPage({super.key, required this.mode});

  /// 어떤 보조 모드의 안내를 보여줄지. 이 값이 투어 종류를 정한다.
  /// (코너 미니뷰 / 고스트 확대)
  final GuideViewMode mode;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // 안내를 끝까지 보지 않고도 나갈 수 있도록 뒤로가기를 남긴다.
      navigationBar: AppBar(onBack: () => context.pop()),
      child: SafeArea(
        bottom: false,
        child: Camera.preview(
          image: const AssetImage(_previewImagePath),
          guideImage: const AssetImage(_guideImagePath),
          showOpacity: true,
          showViewMode: true,
          showTour: true,
          // 이미 본 적이 있어도 눌러서 들어온 것이므로 항상 연다.
          forceTour: true,
          initialViewMode: mode,
          onTourFinished: () => context.pop(),
        ),
      ),
    );
  }
}
