import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// 전량 받아둔 목록을 청크 단위로 나눠 그리는 클라이언트 사이드 페이징 래퍼.
///
/// [items] 전체를 한 번에 그리지 않고 앞에서부터 [pageSize] 개씩만 [builder]
/// 에 넘긴다. 본문 스크롤이 바닥까지 [revealThreshold] 안으로 가까워지면 다음
/// 청크를 드러내고, 노출분이 화면을 못 채워 스크롤 이벤트가 없는 경우도
/// 치수 변화 알림([ScrollMetricsNotification])으로 감지해 화면이 찰 때까지
/// 드러낸다.
///
/// [builder] 는 받은 목록으로 스크롤 가능한 위젯(ListView ·
/// SingleChildScrollView 등)을 만들어 반환해야 한다. 스크롤 알림이 이 위젯까지
/// 버블링되어야 하므로, 중간에 알림을 끊는 위젯을 두면 안 된다.
///
/// 상세 동작과 적용처는 docs/client_side_paging.md 참고.
class LazyRevealList<T> extends StatefulWidget {
  const LazyRevealList({
    super.key,
    required this.items,
    required this.pageSize,
    required this.builder,
    this.revealThreshold = 300.0,
    this.resetKey,
  });

  /// 전체 목록. (서버에서 전량 받아둔 데이터)
  final List<T> items;

  /// 한 번에 드러내는 항목 개수. (청크 크기)
  final int pageSize;

  /// 바닥까지 남은 스크롤 거리가 이 안으로 들어오면 다음 청크를 드러낸다.
  /// (바닥에 닿기 전에 미리 드러나 끊김이 느껴지지 않는다)
  final double revealThreshold;

  /// 값이 바뀌면 노출 개수를 첫 페이지로 되돌린다.
  /// (필터 변경·재조회 등 목록이 갈아끼워지는 시점을 알리는 용도)
  final Object? resetKey;

  /// 드러낸 항목([items] 앞에서부터 노출 개수만큼)으로 본문을 만든다.
  final Widget Function(BuildContext context, List<T> visibleItems) builder;

  @override
  State<LazyRevealList<T>> createState() => _LazyRevealListState<T>();
}

class _LazyRevealListState<T> extends State<LazyRevealList<T>> {
  /// 현재 화면에 드러낸 항목 개수.
  late int _visibleCount = widget.pageSize;

  /// 아직 드러내지 않은 항목이 남았는지 여부.
  bool get _hasMore => _visibleCount < widget.items.length;

  @override
  void didUpdateWidget(LazyRevealList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetKey != oldWidget.resetKey) {
      _visibleCount = widget.pageSize;
    }
  }

  /// 바닥에 가까우면 다음 청크를 드러낸다. (스크롤·치수 변화 알림 공용)
  ///
  /// 다음 청크는 이미 메모리에 있는 데이터를 드러내는 것뿐이라 비동기 작업이
  /// 없고, 항목이 아래쪽에만 더해지므로 드러나는 순간 스크롤이 튀지 않는다.
  void _maybeReveal(ScrollMetrics metrics) {
    if (!_hasMore) return;
    if (metrics.extentAfter > widget.revealThreshold) return;
    setState(() {
      _visibleCount = math.min(
        _visibleCount + widget.pageSize,
        widget.items.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 삭제 등으로 목록이 노출 개수보다 짧아질 수 있어 잘라 맞춘다.
    final visibleItems = _hasMore
        ? widget.items.sublist(0, _visibleCount)
        : widget.items;
    // depth 0 — builder 가 반환한 바깥 스크롤의 알림만 본다.
    // (카드 안쪽 등 중첩 스크롤의 알림에 반응하지 않도록)
    //
    // 치수 변화 알림은 노출분이 화면을 못 채워 스크롤 이벤트가 없을 때를
    // 메운다. 첫 레이아웃과 청크가 늘어난 직후마다 도착하므로, 화면이 찰
    // 때까지 드러내기가 이어지고 다 차면(임계값 초과) 멈춘다.
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        if (notification.depth == 0) _maybeReveal(notification.metrics);
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0) _maybeReveal(notification.metrics);
          return false;
        },
        child: widget.builder(context, visibleItems),
      ),
    );
  }
}
