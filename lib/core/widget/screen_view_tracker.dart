import 'package:flutter/widgets.dart';

/// 자식이 처음 그려질 때 [onView] 를 한 번만 부른다.
///
/// StatelessWidget 화면에 진입 시점 훅을 붙일 때, 화면 전체를 StatefulWidget
/// 으로 바꾸지 않아도 되도록 감싸는 용도다. 콜백만 받으므로 그 안에서 무엇을
/// 하는지는 감싸는 쪽이 정한다.
///
/// 같은 화면에 머무는 동안에는 rebuild 가 몇 번 일어나도 다시 부르지 않는다.
/// (화면을 나갔다 다시 들어오면 State 가 새로 만들어져 다시 불린다)
class ScreenViewTracker extends StatefulWidget {
  const ScreenViewTracker({
    super.key,
    required this.onView,
    required this.child,
  });

  /// 첫 빌드 때 한 번만 불린다.
  final VoidCallback onView;

  final Widget child;

  @override
  State<ScreenViewTracker> createState() => _ScreenViewTrackerState();
}

class _ScreenViewTrackerState extends State<ScreenViewTracker> {
  @override
  void initState() {
    super.initState();
    widget.onView();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
