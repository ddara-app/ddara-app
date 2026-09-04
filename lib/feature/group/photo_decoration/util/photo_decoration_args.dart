import 'package:flutter/widgets.dart';

/// `PhotoDecorationPage` 진입 시 함께 넘기는 인자.
///
/// 사진 상세에서 보던 이미지를 그대로 넘겨, 꾸미기로 들어갈 때 다시 받지 않는다.
class PhotoDecorationArgs {
  const PhotoDecorationArgs({required this.image, this.aspectRatio});

  /// 꾸밀 사진.
  final ImageProvider image;

  /// 사진을 담을 프레임의 가로:세로 비율. null 이면 원본 비율 그대로 담는다.
  final double? aspectRatio;
}
