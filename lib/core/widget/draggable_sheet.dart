import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// 아래로 드래그해 닫을 수 있는 바텀시트 래퍼.
///
/// [showCupertinoModalPopup] 은 바깥 탭 닫기만 지원하므로, 시트 본문을 이
/// 위젯으로 감싸 아래 방향 드래그로도 닫을 수 있게 한다. 손가락을 따라
/// 시트가 내려가고, 시트 높이의 일정 비율을 넘게 내리거나 빠르게 던지면
/// (fling) 닫는다. 그렇지 않으면 원위치로 되돌린다.
class DraggableSheet extends StatefulWidget {
  const DraggableSheet({super.key, required this.child});

  final Widget child;

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet>
    with SingleTickerProviderStateMixin {
  /// 이 속도(px/s)보다 빠르게 아래로 던지면 거리와 무관하게 닫는다.
  static const _flingVelocity = 700.0;

  /// 시트 높이 대비 이 비율 이상 내려간 채 놓으면 닫는다.
  static const _dismissRatio = 0.3;

  /// 놓았을 때 원위치로 되돌리는 애니메이션.
  late final AnimationController _restore =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      )..addListener(
        () => setState(() => _offset = _restoreTween.evaluate(_restore)),
      );

  Tween<double> _restoreTween = Tween<double>(begin: 0, end: 0);

  /// 현재 드래그로 내려간 거리. (0 이상 — 위로는 끌리지 않는다)
  double _offset = 0;

  void _onDragStart(DragStartDetails details) => _restore.stop();

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() => _offset = math.max(0, _offset + details.delta.dy));
  }

  void _onDragEnd(DragEndDetails details) {
    final height = context.size?.height ?? 0;
    final shouldDismiss =
        details.velocity.pixelsPerSecond.dy > _flingVelocity ||
        (height > 0 && _offset > height * _dismissRatio);

    if (shouldDismiss) {
      Navigator.of(context).pop();
      return;
    }

    _restoreTween = Tween<double>(begin: _offset, end: 0);
    _restore
      ..value = 0
      ..animateTo(1, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _restore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: Transform.translate(
        offset: Offset(0, _offset),
        child: widget.child,
      ),
    );
  }
}
