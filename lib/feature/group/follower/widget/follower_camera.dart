import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddara/core/widget/camera/camera.dart';
import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';
import 'package:flutter/cupertino.dart';

/// 따라찍기 촬영 본문. (가이드 사진 위에 투명도·모드 컨트롤 포함)
///
/// 촬영하면 [onCapture] 로 사진 경로를 넘기고, 단계 전환은 상위에서 처리한다.
class FollowerCamera extends StatelessWidget {
  const FollowerCamera({
    super.key,
    required this.onCapture,
    required this.guideImageUrl,
  });

  /// 촬영 완료 시 저장된 이미지 파일 경로를 전달한다.
  final ValueChanged<String> onCapture;

  /// 따라찍기 가이드(친구가 미리 찍은) 사진 URL. 빈 값이면 가이드 뷰를 숨긴다.
  final String guideImageUrl;

  @override
  Widget build(BuildContext context) {
    return Camera(
      // TODO: 모임 상태에 따라 투명도/모드 영역 표시 여부 결정.
      showOpacity: true,
      showViewMode: true,
      // 따라찍기는 가이드 사진에 구도를 맞추는 게 먼저라 고스트 확대로 시작한다.
      initialViewMode: GuideViewMode.ghostZoom,
      // 가이드 사진은 갤러리/상세에서 이미 본 스타터 사진이라 디스크 캐시를 공유한다.
      guideImage: guideImageUrl.isEmpty
          ? null
          : CachedNetworkImageProvider(guideImageUrl),
      onCapture: onCapture,
    );
  }
}
