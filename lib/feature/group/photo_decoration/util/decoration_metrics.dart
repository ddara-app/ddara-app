import 'package:flutter/widgets.dart';

/// 글자 크기. (프레임 가로폭에 대한 비율)
const double decorationTextScale = 0.075;

/// 스티커 한 변. (프레임 가로폭에 대한 비율)
const double decorationStickerScale = 0.22;

/// 사진 프레임과 0~1 비율 좌표 사이를 오가는 환산 규칙.
///
/// 꾸미기 요소의 좌표·굵기·크기는 전부 **프레임 기준 0~1 비율**로만 보관한다.
/// 화면 폭이 달라져도 사진 위 같은 자리에 남고, 나중에 원본 해상도로 다시
/// 그릴 때도 같은 값을 그대로 쓰기 위해서다.
///
/// 이 환산이 화면 코드마다 흩어지면 규칙이 어긋나므로 여기 한곳에 모은다.
/// (그리는 쪽 `StrokePainter` 와 얹는 쪽 `DecorationCanvas` 가 공유한다)
extension DecorationFrame on Size {
  /// 프레임 안 픽셀 좌표 → 0~1 비율. (밖으로 나간 값은 가장자리에 붙인다)
  Offset toRatio(Offset local) => Offset(
    (local.dx / width).clamp(0.0, 1.0),
    (local.dy / height).clamp(0.0, 1.0),
  );

  /// 이동량(픽셀) → 0~1 비율. 위치와 달리 잘라내지 않는다.
  ///
  /// 손가락이 움직인 만큼 요소도 정확히 움직이도록, 프레임 전체 크기로 나눈다.
  Offset toRatioDelta(Offset delta) =>
      Offset(delta.dx / width, delta.dy / height);

  /// 0~1 비율 좌표 → 프레임 안 픽셀 좌표.
  Offset toPixels(Offset ratio) => Offset(ratio.dx * width, ratio.dy * height);

  /// 0~1 비율 굵기·크기 → 픽셀. (가로폭 기준이라 축 왜곡이 없다)
  double scaleToPixels(double ratio) => ratio * width;
}
