import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/widgets.dart';

/// 꾸미기 도구. (하단 툴바에서 하나만 활성)
enum DecorationTool {
  /// 손가락으로 선을 그린다.
  pen,

  /// 문지른 자리를 파낸다. 펜과 똑같이 획으로 남고, 칠할 때만 지우는 붓이 된다.
  /// (텍스트·스티커는 획이 아니라 별도 요소라 영향을 받지 않는다)
  eraser,

  /// 탭한 자리에 글자를 넣는다.
  text,

  /// 고른 스티커를 붙인다.
  sticker,
}

/// 손가락으로 그은 획 하나. 펜과 지우개가 같은 타입을 쓴다.
///
/// [points] 와 [width] 는 모두 **사진 프레임 기준 0~1 비율**이다. 화면 크기나
/// 저장 해상도가 달라져도 같은 그림이 나오도록 픽셀 값을 담지 않는다.
/// ([width] 는 프레임 가로폭에 대한 비율)
///
/// [isEraser] 인 획은 색을 칠하는 대신 그때까지 칠해진 것을 파낸다. 그래서
/// 획 목록의 **순서가 곧 칠한 순서**이고, 지운 뒤 같은 자리에 그린 선은 다시
/// 지워지지 않는다. (일반 그림 앱과 같은 동작)
class PenStroke {
  const PenStroke({
    required this.points,
    required this.color,
    required this.width,
    this.isEraser = false,
  });

  final List<Offset> points;

  /// 칠할 색. 지우개 획에서는 쓰이지 않는다. (파내기만 한다)
  final Color color;

  final double width;
  final bool isEraser;

  /// 점을 하나 이어 붙인 새 획.
  PenStroke addPoint(Offset point) => PenStroke(
    points: [...points, point],
    color: color,
    width: width,
    isEraser: isEraser,
  );
}

/// 사진 위에 얹어 두고 끌어서 옮기는 요소. (텍스트·스티커)
///
/// [position] 은 사진 프레임 기준 0~1 비율의 **중심점**이다.
sealed class OverlayItem {
  const OverlayItem({required this.id, required this.position});

  /// 선택·삭제 대상을 가리키는 식별자. (목록 순서가 바뀌어도 유지된다)
  final int id;

  final Offset position;

  /// 위치만 바꾼 사본.
  OverlayItem moveTo(Offset next);
}

/// 사진 위의 글자.
final class TextOverlay extends OverlayItem {
  const TextOverlay({
    required super.id,
    required super.position,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  TextOverlay moveTo(Offset next) =>
      TextOverlay(id: id, position: next, text: text, color: color);

  /// 자리는 그대로 두고 내용·색만 바꾼 사본.
  TextOverlay edited({required String text, required Color color}) =>
      TextOverlay(id: id, position: position, text: text, color: color);
}

/// 사진 위의 스티커.
final class StickerOverlay extends OverlayItem {
  const StickerOverlay({
    required super.id,
    required super.position,
    required this.sticker,
  });

  final StickerData sticker;

  @override
  StickerOverlay moveTo(Offset next) =>
      StickerOverlay(id: id, position: next, sticker: sticker);
}
