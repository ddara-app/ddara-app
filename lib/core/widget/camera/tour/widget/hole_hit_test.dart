import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// 구멍 안쪽 터치를 아래(실제 화면 위젯)로 통과시키는 래퍼.
///
/// 사용자가 직접 눌러봐야 진행되는 스텝에서 쓴다. [hole] 은 화면 좌표계
/// 기준이므로 이 위젯은 화면 전체를 덮어야 하고 `SafeArea` 안쪽에 두면 안 된다.
class HoleHitTest extends SingleChildRenderObjectWidget {
  const HoleHitTest({
    super.key,
    required this.hole,
    required this.passThrough,
    required Widget super.child,
  });

  /// 터치를 통과시킬 영역. null 이면 통과 없음.
  final Rect? hole;

  /// 통과 여부. false 면 모든 터치를 이 레이어가 받는다.
  final bool passThrough;

  @override
  RenderHoleHitTest createRenderObject(BuildContext context) =>
      RenderHoleHitTest(hole: hole, passThrough: passThrough);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderHoleHitTest renderObject,
  ) {
    renderObject
      ..hole = hole
      ..passThrough = passThrough;
  }
}

/// [HoleHitTest] 의 렌더 객체.
///
/// 두 값은 히트 테스트에만 쓰이고 그리기에는 관여하지 않으므로,
/// 값이 바뀌어도 레이아웃·페인트를 다시 요청할 필요가 없다.
class RenderHoleHitTest extends RenderProxyBox {
  RenderHoleHitTest({this.hole, this.passThrough = false});

  /// 터치를 통과시킬 영역.
  Rect? hole;

  /// 통과 여부.
  bool passThrough;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // 구멍 안쪽이면 이 레이어를 비켜, 아래의 실제 위젯이 터치를 받게 한다.
    final hole = this.hole;
    if (passThrough && hole != null && hole.contains(position)) return false;
    return super.hitTest(result, position: position);
  }
}
