/// 촬영 화면 가이드 안내의 종류. (서버가 시청 기록을 이 키로 관리한다)
enum CameraGuideKey {
  /// 코너 미니뷰 안내.
  miniView('MINI_VIEW'),

  /// 고스트 확대 안내.
  ghostView('GHOST_VIEW');

  const CameraGuideKey(this.value);

  /// 서버와 주고받는 문자열.
  final String value;

  /// 서버가 내려준 문자열을 enum 으로 역매핑. 모르는 값이면 null.
  ///
  /// 앱이 아직 모르는 키가 늘어나도 조회가 실패하지 않도록 null 을 돌려주고,
  /// 호출부가 걸러낸다.
  static CameraGuideKey? fromValue(String? value) {
    for (final key in CameraGuideKey.values) {
      if (key.value == value) return key;
    }
    return null;
  }
}
