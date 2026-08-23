import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/widget/camera/camera.dart';
import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';
import 'package:ddara/core/widget/camera/tour/camera_tour_steps.dart';
import 'package:flutter/cupertino.dart';

/// 따라찍기 촬영 본문. (가이드 사진 위에 투명도·모드 컨트롤 포함)
///
/// 촬영하면 [onCapture] 로 사진 경로를 넘기고, 단계 전환은 상위에서 처리한다.
class FollowerCamera extends StatelessWidget {
  const FollowerCamera({
    super.key,
    required this.onCapture,
    required this.onRequestCameraPermission,
    required this.onOpenSettings,
    required this.guideImageUrl,
    this.forceTour = false,
    this.tourRestartToken = 0,
    this.cornerTourSeen,
    this.ghostTourSeen,
    this.onTourFinished,
  });

  /// 촬영 완료 시 저장된 이미지 파일 경로를 전달한다.
  final ValueChanged<String> onCapture;

  /// 카메라 권한 확인·요청. 허용 여부를 돌려준다. (ViewModel 이 맡는다)
  final Future<bool> Function() onRequestCameraPermission;

  /// 권한 거부 안내에서 '설정으로 이동'을 눌렀을 때.
  final VoidCallback onOpenSettings;

  /// 따라찍기 가이드(친구가 미리 찍은) 사진 URL. 빈 값이면 가이드 뷰를 숨긴다.
  ///
  /// `assets/` 로 시작하면 번들 이미지로 읽는다. 진행 중인 회차가 없을 때도
  /// 가이드 투어를 확인할 수 있도록 더미 사진을 넘기는 경로다.
  final String guideImageUrl;

  /// 이미 본 적이 있어도 가이드 투어를 처음부터 다시 띄운다.
  final bool forceTour;

  /// 값이 바뀌면 투어를 다시 연다. (AppBar 도움말 버튼이 올린다)
  final int tourRestartToken;

  /// 진입 안내(코너 미니뷰)를 이미 본 적이 있는지.
  /// null 이면 아직 확인 중이라 열지 않는다.
  final bool? cornerTourSeen;

  /// 고스트 확대 안내를 이미 본 적이 있는지. (코너 안내와 따로 관리)
  final bool? ghostTourSeen;

  /// 투어를 끝까지 봤을 때, 끝난 투어의 종류를 전달한다.
  /// 완료 저장은 상위 화면이 맡는다.
  final ValueChanged<CameraTourKind>? onTourFinished;

  /// 가이드 사진 provider. 빈 값이면 null 을 돌려 가이드 뷰를 숨긴다.
  ImageProvider? get _guideImage {
    if (guideImageUrl.isEmpty) return null;
    if (guideImageUrl.startsWith('assets/')) return AssetImage(guideImageUrl);
    // 갤러리/상세에서 이미 본 스타터 사진이라 디스크 캐시를 공유한다.
    return CachedNetworkImageProvider(guideImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Camera(
      // TODO: 모임 상태에 따라 투명도/모드 영역 표시 여부 결정.
      showOpacity: true,
      showViewMode: true,
      // 가이드가 프리뷰를 덮지 않도록 코너 미니뷰로 시작한다. 정밀하게 맞추고
      // 싶으면 고스트 확대로 바꾸면 된다. (가이드 투어도 같은 순서로 안내한다)
      initialViewMode: GuideViewMode.cornerMini,
      // 가이드 사진·투명도·모드가 모두 있는 화면이라 첫 진입에 사용법을 안내한다.
      showTour: true,
      forceTour: forceTour,
      tourRestartToken: tourRestartToken,
      guideImage: _guideImage,
      cornerTourSeen: cornerTourSeen,
      ghostTourSeen: ghostTourSeen,
      onTourFinished: onTourFinished,
      onCapture: onCapture,
      onRequestCameraPermission: onRequestCameraPermission,
      onOpenSettings: onOpenSettings,
    );
  }
}
