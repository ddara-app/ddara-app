import 'package:flutter/cupertino.dart';

/// 본문 목록 드래그를 넘겨받아 시트 높이를 움직이는 쪽의 창구.
///
/// 스크롤 포지션은 시트 State 를 직접 참조하지 않고 이 인터페이스로만 접근한다.
abstract interface class SheetDragHost {
  /// 입력 포커스를 쥐고 있는지. (= 키보드가 떠 있어 시트가 최대 높이인 상태)
  bool get keyboardFocused;

  /// 아직 더 확장할 여지가 남았는지.
  bool get canExpand;

  /// 확장이 최대·기본 어느 쪽에도 붙지 않은 중간 상태인지.
  /// (여기서 손을 떼면 관성을 목록이 아니라 높이 스냅에 쓴다)
  bool get isExpandMidway;

  /// 시트가 기본 자리보다 아래로 끌려 내려가 있는지.
  bool get isDraggedDown;

  /// 키보드로 커져 있던 높이를 이어받아 축소를 시작한다.
  void takeOverKeyboardExpand();

  /// 본문 드래그 이동량을 시트에 흡수시킨다. (아래로 = 양수)
  void applyBodyDrag(double delta);

  /// 기본 높이 아래로 끌어내린 채 끝난 드래그. 닫을지 되돌릴지는 부모가 정한다.
  /// [velocityDown] 은 아래 방향이 양수인 속도(px/s).
  void endBodyCloseDrag(double velocityDown);

  /// 확장 드래그를 놓았을 때 최대/기본 중 한쪽으로 붙인다.
  /// [velocityTowardMax] 는 확장 방향(위)이 양수인 속도(px/s).
  void snapExpand(double velocityTowardMax);
}

/// 본문 목록 드래그를 시트 확장과 나눠 갖기 위한 스크롤 컨트롤러.
/// ([_SheetScrollPosition] 을 붙이는 역할만 한다)
class SheetScrollController extends ScrollController {
  SheetScrollController(this._host);

  final SheetDragHost _host;

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _SheetScrollPosition(
      _host,
      physics: physics,
      context: context,
      oldPosition: oldPosition,
    );
  }
}

/// 본문 목록의 스크롤 위치. 드래그를 시트 확장과 목록 스크롤에 나눠 준다.
///
/// 위로 드래그하면 시트가 최대 높이가 될 때까지 확장에 먼저 쓰고, 그 뒤에
/// 목록을 스크롤한다. (댓글이 적어 스크롤할 게 없어도 확장은 된다)
/// 아래로 드래그하면 목록이 맨 위로 돌아온 뒤에 확장을 줄이고, 기본 높이에
/// 도달한 뒤에도 계속 끌어내리면 헤더 드래그처럼 시트 닫힘으로 이어진다.
class _SheetScrollPosition extends ScrollPositionWithSingleContext {
  _SheetScrollPosition(
    this._host, {
    required super.physics,
    required super.context,
    super.oldPosition,
  });

  final SheetDragHost _host;

  /// 이 포지션의 드래그가 시트 확장을 움직이는 중인지 여부.
  ///
  /// [goBallistic] 은 드래그 종료 외에도 시트 높이 변화(뷰포트 크기 변경)로
  /// 유휴 상태가 재정렬될 때도 불리므로, 시트 쪽 드래그 플래그가 아니라
  /// 이 포지션이 직접 만든 드래그인지로 가려낸다. (헤더 드래그로 높이가
  /// 변하는 동안 끼어들어 확장을 되돌리지 않도록)
  bool _bodyDragging = false;

  @override
  void applyUserOffset(double delta) {
    // 키보드가 떠 있는 동안(높이 = 최대) —
    if (_host.keyboardFocused) {
      // 목록 맨 위에서 아래로 끌면 키보드를 내리고, 커져 있던 높이를
      // 이어받아 그대로 축소를 시작한다.
      if (delta > 0 && pixels <= minScrollExtent) {
        _host.takeOverKeyboardExpand();
        _bodyDragging = true;
        _host.applyBodyDrag(delta);
        return;
      }
      // 그 외에는 높이를 포커스가 관리하므로 목록만 스크롤한다.
      super.applyUserOffset(delta);
      return;
    }
    // 위로 드래그(음수): 목록이 맨 위면 시트가 최대 높이가 될 때까지
    // 확장에 먼저 쓰고, 그 뒤에야 목록이 스크롤된다.
    if (delta < 0 && pixels <= minScrollExtent && _host.canExpand) {
      _bodyDragging = true;
      _host.applyBodyDrag(delta);
      return;
    }
    // 아래로 드래그(양수): 목록이 맨 위면 확장을 먼저 줄이고, 기본 높이에
    // 도달한 뒤에는 시트를 닫는 쪽(닫힘 진행도)으로 넘긴다.
    if (delta > 0 && pixels <= minScrollExtent) {
      _bodyDragging = true;
      _host.applyBodyDrag(delta);
      return;
    }
    super.applyUserOffset(delta);
  }

  @override
  void goBallistic(double velocity) {
    // 본문 드래그가 확장을 움직이던 중 손을 뗀 경우에만 높이를 스냅한다.
    // 확장 구간 중간에서 놓았을 땐 관성을 높이 스냅에 쓰고 목록에는 넘기지
    // 않는다. (velocity 는 손가락을 위로 튕기면 양수 — 확장 방향과 같다)
    if (_bodyDragging) {
      _bodyDragging = false;
      // 시트가 기본 높이 아래로 내려간 채 놓았으면 닫을지 되돌릴지 부모가
      // 판단한다. (아래 방향이 양수가 되도록 속도를 뒤집어 넘긴다)
      if (_host.isDraggedDown) {
        _host.endBodyCloseDrag(-velocity);
        super.goBallistic(0);
        return;
      }
      final mid = _host.isExpandMidway;
      _host.snapExpand(mid ? velocity : 0);
      if (mid) {
        super.goBallistic(0);
        return;
      }
    }
    super.goBallistic(velocity);
  }
}
