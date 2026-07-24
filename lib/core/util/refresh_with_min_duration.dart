/// 당겨서 새로고침 실행. [refresh] 가 아무리 빨리 끝나도 인디케이터를 최소
/// [min] 동안 상단에 고정했다가 풀어, 새로고침이 일어났음을 인지할 수 있게
/// 한다. (홈 두 탭 · 모임 상세가 공용)
Future<void> refreshWithMinDuration(
  Future<void> Function() refresh, {
  Duration min = const Duration(seconds: 1),
}) {
  return Future.wait([refresh(), Future<void>.delayed(min)]);
}
