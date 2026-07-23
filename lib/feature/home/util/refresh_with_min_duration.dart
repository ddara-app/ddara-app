/// 당겨서 새로고침 실행. 조회가 아무리 빨리 끝나도 인디케이터를 최소 1초는
/// 상단에 고정했다가 풀어, 새로고침이 일어났음을 인지할 수 있게 한다.
/// (모임 페이지와 동일 — core 승격 후보는 리팩토링 노트 [A-2] 참고)
Future<void> refreshWithMinDuration(Future<void> Function() refresh) {
  return Future.wait([
    refresh(),
    Future<void>.delayed(const Duration(seconds: 1)),
  ]);
}
