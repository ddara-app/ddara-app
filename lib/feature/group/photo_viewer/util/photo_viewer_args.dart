import 'package:flutter/widgets.dart';

/// `PhotoViewerPage` 진입 시 함께 넘기는 인자.
///
/// 보여줄 이미지 자체를 넘기므로 경로에는 담지 않는다. 목록 카드가 이미 받아 둔
/// [ImageProvider] 를 그대로 넘겨, 상세로 들어갈 때 사진을 다시 받지 않는다.
class PhotoViewerArgs {
  const PhotoViewerArgs({
    required this.image,
    this.heroTag,
    this.aspectRatio,
    this.locked = false,
    this.onDecorate,
  });

  /// 크게 보여줄 이미지.
  final ImageProvider image;

  /// 목록 카드와 상세를 잇는 Hero 전환 태그. null 이면 전환 애니메이션 없이 표시.
  final Object? heroTag;

  /// 카드에서 보이던 프레임 그대로 보여줄 때 쓰는 카드의 가로:세로 비율.
  /// 지정하면 이 비율의 프레임에 cover 로 잘라 담아, 카드에서 잘렸던 부분이
  /// 추가로 드러나지 않는다. null 이면 원본 전체를 보여준다. (contain)
  final double? aspectRatio;

  /// 잠긴 사진 여부. true 면 상세에서도 블러 + 가운데 자물쇠를 유지한다.
  /// (본인이 아직 업로드하지 않아 타인 사진이 잠긴 경우)
  final bool locked;

  /// 상단 바 '꾸미기' 버튼을 눌렀을 때. null 이면 버튼을 비활성으로 둔다.
  final VoidCallback? onDecorate;
}
