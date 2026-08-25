import 'package:flutter/widgets.dart';

/// 목록을 맨 위로 되돌리는 데 걸리는 시간의 하한·상한.
///
/// 스크롤 거리에 비례해 정한다 — 가까우면 짧게 끝내고, 아무리 멀어도 상한을
/// 넘지 않아 되돌아오는 동안 화면이 붙잡히지 않는다.
const _minDuration = Duration(milliseconds: 200);
const _maxDuration = Duration(milliseconds: 600);

/// 떨어진 거리 1px 마다 더해지는 시간(ms).
const double _msPerPixel = 0.3;

/// 이미 보고 있는 탭을 다시 눌렀을 때 목록을 맨 위로 되돌린다.
/// (홈 · 알림의 탭 재선택이 공용)
extension ScrollToTop on ScrollController {
  /// 스크롤을 최상단으로 되돌린다.
  ///
  /// 아직 그려지지 않았거나(빈 화면) 이미 맨 위면 아무 일도 하지 않는다.
  void animateToTop() {
    if (!hasClients || offset <= 0) return;

    animateTo(
      0,
      duration: _durationFor(offset),
      // 초반에 확 올라가고, 최상단에 가까워질수록 눈에 띄게 느려진다.
      curve: Curves.easeOutQuint,
    );
  }
}

/// [distance] px 만큼 떨어져 있을 때 되돌리는 데 쓸 시간.
///
/// 거리와 무관하게 고정하면 멀리서 되돌아올 때 순간이동처럼 보인다.
Duration _durationFor(double distance) {
  final milliseconds = _minDuration.inMilliseconds + distance * _msPerPixel;

  return Duration(
    milliseconds: milliseconds
        .clamp(
          _minDuration.inMilliseconds.toDouble(),
          _maxDuration.inMilliseconds.toDouble(),
        )
        .toInt(),
  );
}
