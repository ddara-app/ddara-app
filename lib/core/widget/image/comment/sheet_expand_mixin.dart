import 'dart:math' as math;

import 'package:ddara/core/widget/image/comment/photo_comment_sheet.dart';
import 'package:ddara/core/widget/image/comment/sheet_scroll_position.dart';
import 'package:flutter/cupertino.dart';

/// 시트 기본 높이. (화면 높이 대비 비율)
const double _baseHeightFraction = 0.65;

/// 시트 최대 높이. (키보드가 올라오거나 핸들을 위로 드래그해 확장했을 때)
const double _maxHeightFraction = 0.9;

/// 확장 드래그를 놓았을 때 이 속도(px/s)보다 빠르면 위치와 무관하게
/// 그 방향(위 = 최대, 아래 = 기본)으로 스냅한다.
const double _expandSnapVelocity = 300.0;

/// 댓글 시트의 높이 계산과 드래그 배분.
///
/// 핸들·헤더 드래그와 본문 목록 드래그를 같은 규칙([applyExpandDrag])으로
/// 처리해, 시트 확장 → 닫힘 진행도 순으로 이동량을 나눠 준다. 닫힘 진행도는
/// 부모(사진 뷰어)가 이미지 도킹과 공유하므로 콜백으로 넘긴다.
///
/// 높이는 `State` 의 [MediaQuery] · 입력 포커스에 의존하므로 별도 클래스가
/// 아니라 mixin 으로 둔다. 화면에서 받는 것은 입력 포커스 노드 하나뿐이다.
mixin SheetExpandMixin on State<PhotoCommentSheet>, WidgetsBindingObserver
    implements SheetDragHost {
  /// 입력창 포커스 노드. 키보드가 떠 있는지 판단하고, 확장 드래그를 시작할 때
  /// 포커스를 놓는 데 쓴다.
  FocusNode get inputFocusNode;

  /// 수동 확장 진행도. (0 = 기본 높이 · 1 = 최대 높이)
  /// 핸들을 위로 드래그하면 커지고, 아래로 드래그하면 먼저 줄어든 뒤
  /// 닫힘 진행도로 넘어간다. 시트가 완전히 닫히면 0 으로 되돌린다.
  double _expand = 0;

  /// 드래그 중 여부. 드래그 중에는 높이가 손가락을 즉시 따라와야
  /// 하므로 높이 애니메이션을 끈다.
  bool _dragging = false;

  /// 직전에 관찰한 키보드 표시 여부. (키보드가 내려간 '순간' 을 가려내는 데 쓴다)
  bool _keyboardWasVisible = false;

  bool get isDragging => _dragging;

  @override
  void initState() {
    super.initState();
    // 키보드 높이 변화를 관찰한다. ([didChangeMetrics])
    WidgetsBinding.instance.addObserver(this);
    // 시트가 화면 밖으로 완전히 사라지면 수동 확장을 기본 높이로 되돌린다.
    // (다시 열 때 항상 기본 높이에서 시작하도록)
    widget.position.addListener(_onPositionChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.position.removeListener(_onPositionChanged);
    super.dispose();
  }

  /// 키보드가 (뒤로가기·스와이프 등으로) 내려가면 입력 포커스도 해제한다.
  /// 포커스가 남아 있으면 시트가 커진 높이(0.9)를 유지해 버리기 때문이다.
  ///
  /// 높이는 크기 비교만 하므로 [View] 의 물리 픽셀 값을 그대로 쓴다.
  /// (이 콜백은 MediaQuery 가 갱신되기 전에 불릴 수 있어 View 에서 직접 읽는다)
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final keyboardVisible = View.of(context).viewInsets.bottom > 0;
    if (_keyboardWasVisible && !keyboardVisible && inputFocusNode.hasFocus) {
      inputFocusNode.unfocus();
    }
    _keyboardWasVisible = keyboardVisible;
  }

  /// 시트가 화면 밖으로 완전히 사라진 순간 수동 확장을 되돌린다.
  /// (숨겨진 동안의 높이 변화라 화면에는 드러나지 않는다)
  void _onPositionChanged() {
    if (widget.position.value.dy >= 1 && _expand != 0 && mounted) {
      setState(() => _expand = 0);
    }
  }

  /// 확장 구간(기본 → 최대)의 픽셀 크기. (드래그량 ↔ 확장 진행도 환산용)
  double get _expandRange =>
      MediaQuery.sizeOf(context).height *
      (_maxHeightFraction - _baseHeightFraction);

  /// 현재 시트 높이. 키보드가 올라오면 최대(0.9) 고정, 평소엔 기본(0.65)에
  /// 확장한 만큼([_expand]) 더한 값이다. 높이는 실제 인셋 대신 포커스 여부로
  /// 판단해, 키보드가 내려가기 시작하는 순간부터 시트도 함께 줄어들게 한다.
  double get sheetHeight {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return inputFocusNode.hasFocus
        ? screenHeight * _maxHeightFraction
        : screenHeight * _baseHeightFraction + _expandRange * _expand;
  }

  /// 핸들 드래그 시작. 키보드가 떠 있었다면(높이 = 최대) 확장을 최대로 맞춰
  /// 두고 포커스를 해제한다 — 높이가 튀지 않고 손가락이 이어받게 하기 위함.
  void onHeaderDragStart() {
    setState(() {
      _dragging = true;
      if (inputFocusNode.hasFocus) _expand = 1;
    });
    inputFocusNode.unfocus();
  }

  /// 드래그 이동량 [delta](아래 = 양수 px)를 시트에 배분한다. 위로 끌면
  /// 시트를 끝까지 올린 뒤 남는 만큼 확장하고, 아래로 끌면 확장을 먼저 줄인
  /// 뒤 남는 만큼 닫힘 진행도로 넘긴다. (핸들·헤더 드래그와 본문 드래그 공용,
  /// 진행도는 부모가 이미지 도킹과 공유하므로 함께 움직인다)
  void applyExpandDrag(double delta) {
    final height = sheetHeight;
    if (delta < 0) {
      // 시트가 (드래그로) 내려가 있으면 먼저 원래 자리까지 되올린다.
      final toFull = widget.position.value.dy * height;
      final restore = math.min(-delta, toFull);
      if (restore > 0) widget.onDragProgress(restore / height);
      // 남은 이동량은 확장으로 쓴다.
      final leftover = -delta - restore;
      if (leftover > 0 && _expand < 1) {
        setState(() => _expand = math.min(1, _expand + leftover / _expandRange));
      }
    } else {
      // 확장분을 먼저 소진한다.
      final consumed = math.min(delta, _expand * _expandRange);
      if (consumed > 0) {
        setState(() => _expand -= consumed / _expandRange);
      }
      // 남은 이동량은 닫힘 진행도로 넘긴다.
      final leftover = delta - consumed;
      if (leftover > 0) widget.onDragProgress(-leftover / height);
    }
  }

  /// 핸들 드래그 종료. 시트가 기본 높이 아래로 내려가 있으면 닫을지 되돌릴지
  /// 부모가 판단하고, 확장 구간에서 놓았으면 최대/기본 높이에 스냅한다.
  void onHeaderDragEnd(DragEndDetails details) {
    if (widget.position.value.dy > 0) {
      setState(() => _dragging = false);
      widget.onDragEnd(details);
      return;
    }
    // primaryVelocity 는 아래가 양수라 확장 방향(위 = 양수)으로 뒤집는다.
    snapExpand(-(details.primaryVelocity ?? 0));
  }

  /// 핸들 드래그가 취소됐을 때. (높이 애니메이션만 되살린다)
  void cancelHeaderDrag() => setState(() => _dragging = false);

  // ── SheetDragHost ─────────────────────────────────────────────────

  @override
  bool get keyboardFocused => inputFocusNode.hasFocus;

  @override
  bool get canExpand => _expand < 1;

  @override
  bool get isExpandMidway => _expand > 0 && _expand < 1;

  @override
  bool get isDraggedDown => widget.position.value.dy > 0;

  /// 본문 드래그가 키보드로 커져 있던 높이(최대)를 이어받아 축소를 시작한다.
  /// 확장을 최대로 맞춰 높이가 튀지 않게 한 뒤 키보드를 내린다.
  @override
  void takeOverKeyboardExpand() {
    setState(() => _expand = 1);
    inputFocusNode.unfocus();
  }

  /// 본문 목록 드래그를 시트에 흡수한다.
  /// [delta] 는 스크롤 좌표계 그대로 — 손가락 아래로 = 양수. 배분 규칙은
  /// 핸들·헤더 드래그와 같다. ([applyExpandDrag])
  @override
  void applyBodyDrag(double delta) {
    setState(() => _dragging = true);
    applyExpandDrag(delta);
  }

  /// 확장 드래그를 놓았을 때 최대/기본 높이 중 한쪽으로 스냅한다.
  /// [velocityTowardMax] 는 확장 방향(위)이 양수인 속도(px/s). 빠르면 그
  /// 방향으로, 느리면 가까운 쪽으로 붙는다.
  @override
  void snapExpand(double velocityTowardMax) {
    setState(() {
      _dragging = false;
      if (velocityTowardMax >= _expandSnapVelocity) {
        _expand = 1;
      } else if (velocityTowardMax <= -_expandSnapVelocity) {
        _expand = 0;
      } else {
        _expand = _expand >= 0.5 ? 1 : 0;
      }
    });
  }

  /// 본문 드래그가 시트를 기본 높이 아래로 끌어내린 채 끝났을 때 —
  /// 헤더 드래그와 마찬가지로 닫을지 되돌릴지 판단을 부모에 넘긴다.
  /// [velocityDown] 은 아래 방향이 양수인 속도(px/s).
  @override
  void endBodyCloseDrag(double velocityDown) {
    setState(() => _dragging = false);
    widget.onDragEnd(
      DragEndDetails(
        primaryVelocity: velocityDown,
        velocity: Velocity(pixelsPerSecond: Offset(0, velocityDown)),
      ),
    );
  }
}
