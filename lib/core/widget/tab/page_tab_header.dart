import 'dart:ui' show lerpDouble;

import 'package:ddara/core/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show listEquals;

/// 탭 하나의 고정 폭. (라벨 길이와 무관하게 같은 폭을 쓸 때)
///
/// 짧은 라벨이 밑줄과 밀착해 보이지 않도록 둔 여유다.
/// 헤더를 쓰는 화면끼리 밑줄 길이가 같아지는 효과도 있다.
const double pageTabWidth = 75;

/// 탭 헤더를 감싸는 표준 여백.
///
/// 헤더를 쓰는 화면끼리 리듬이 어긋나지 않도록 한곳에 둔다.
/// (좌우는 Page 규칙의 s5)
const EdgeInsets pageTabHeaderPadding = EdgeInsets.fromLTRB(
  AppSpacing.s5,
  AppSpacing.s5,
  AppSpacing.s5,
  AppSpacing.s7,
);

/// 탭 터치 시 페이지 이동 애니메이션 시간.
const Duration _tabSwitchDuration = Duration(milliseconds: 300);

/// 탭 인디케이터 두께.
const double _indicatorHeight = 3;

/// 좌측 정렬 탭 헤더 (라벨 + 밑줄 인디케이터).
///
/// 홈·알림처럼 [PageView] 로 화면을 나눈 곳이 공유한다.
///
/// 고정 프레임 애니메이션 대신 [PageView] 의 스크롤 진행도(0.0~1.0)를 매 프레임
/// 읽어 라벨 색과 인디케이터 위치·폭을 보간한다. 그래서 손가락 드래그를
/// 그대로 따라오고, 탭 터치 시에도 페이지 이동과 완전히 동기화된다.
///
/// 라벨 렌더링 폭은 프레임 간 불변이므로 라벨·textScaler 가 바뀔 때만 계산해
/// 캐시한다. (스와이프 중 매 프레임 TextPainter 를 만들지 않는다)
class PageTabHeader extends StatefulWidget {
  const PageTabHeader({
    super.key,
    required this.controller,
    required this.labels,
    required this.currentIndex,
    this.tabWidth,
    this.onReselected,
  });

  /// 본문 [PageView] 와 공유하는 컨트롤러. (진행도 소스)
  final PageController controller;

  /// 탭 라벨 목록. (표시 순서 = 페이지 순서)
  final List<String> labels;

  /// 현재 선택된 탭 인덱스. (컨트롤러 치수 미확정 시 진행도 대체값)
  final int currentIndex;

  /// 탭 하나의 고정 폭. null 이면 라벨 길이만큼만 차지한다.
  ///
  /// 라벨이 짧아 밑줄이 밀착해 보이는 헤더는 [pageTabWidth] 를 넘긴다.
  final double? tabWidth;

  /// 이미 보고 있는 탭을 다시 눌렀을 때. (목록을 맨 위로 되돌리는 용도)
  ///
  /// 넘기지 않으면 재선택은 아무 일도 하지 않는다.
  final ValueChanged<int>? onReselected;

  @override
  State<PageTabHeader> createState() => _PageTabHeaderState();
}

class _PageTabHeaderState extends State<PageTabHeader> {
  /// 라벨별 렌더링 폭 캐시. (인디케이터 위치·폭 보간의 기준)
  List<double> _labelWidths = const [];

  /// 캐시를 계산했을 때의 textScaler. 바뀌면(시스템 글자 크기 변경) 재계산한다.
  TextScaler? _textScaler;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final textScaler = MediaQuery.textScalerOf(context);
    if (_textScaler != textScaler) {
      _textScaler = textScaler;
      _computeLabelWidths();
    }
  }

  @override
  void didUpdateWidget(covariant PageTabHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.labels, widget.labels) ||
        oldWidget.tabWidth != widget.tabWidth) {
      _computeLabelWidths();
    }
  }

  void _computeLabelWidths() {
    final fixed = widget.tabWidth;
    _labelWidths = fixed != null
        ? List<double>.filled(widget.labels.length, fixed)
        : [for (final label in widget.labels) _labelWidth(label, _textScaler!)];
  }

  /// [AppTypography.label] 스타일 기준 라벨의 렌더링 폭.
  double _labelWidth(String label, TextScaler textScaler) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: AppTypography.label),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  /// PageView 의 현재 페이지 값(스와이프 진행도 포함).
  /// 첫 레이아웃 전(치수 미확정)에는 선택 인덱스로 대체한다.
  double get _currentPage {
    final controller = widget.controller;
    final hasPage = controller.hasClients && controller.position.haveDimensions;
    return hasPage ? controller.page! : widget.currentIndex.toDouble();
  }

  void _onTabTap(int index) {
    if (index == widget.currentIndex) {
      widget.onReselected?.call(index);
      return;
    }
    widget.controller.animateToPage(
      index,
      duration: _tabSwitchDuration,
      // 빠르게 출발해 부드럽게 감속 착지.
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      // PageController 가 스크롤마다 notify 하므로 진행도를 프레임 단위로 반영.
      animation: widget.controller,
      builder: (context, _) {
        final page = _currentPage.clamp(
          0.0,
          (widget.labels.length - 1).toDouble(),
        );

        // 각 라벨의 시작 x 좌표. (Row 간격 s4 반영)
        final lefts = <double>[];
        var x = 0.0;
        for (final width in _labelWidths) {
          lefts.add(x);
          x += width + AppSpacing.s4;
        }

        // 드래그 중에는 두 탭 사이에 걸쳐 있으므로, 양쪽 값을 진행도로 보간한다.
        final from = page.floor();
        final to = page.ceil();
        final t = page - from;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: AppSpacing.s4,
              children: [
                for (var i = 0; i < widget.labels.length; i++)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTabTap(i),
                    child: SizedBox(
                      // 고정 폭이 없으면 글자 너비만큼만 차지한다.
                      width: widget.tabWidth,
                      child: Text(
                        widget.labels[i],
                        // 고정 폭일 때 남는 공간을 양쪽으로 나눈다.
                        // (폭을 안 준 헤더는 글자 너비만큼이라 영향이 없다)
                        textAlign: TextAlign.center,
                        style: AppTypography.label.copyWith(
                          // 진행도에 비례해 회색과 흰색 사이를 오간다.
                          color: Color.lerp(
                            AppColors.textTertiary,
                            AppColors.textPrimary,
                            (1 - (page - i).abs()).clamp(0.0, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s3),
            // 선택 라벨 아래로 미끄러지는 인디케이터. 위치·폭을 진행도로 보간한다.
            SizedBox(
              height: _indicatorHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    left: lerpDouble(lefts[from], lefts[to], t)!,
                    width: lerpDouble(_labelWidths[from], _labelWidths[to], t)!,
                    top: 0,
                    bottom: 0,
                    child: const ColoredBox(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
