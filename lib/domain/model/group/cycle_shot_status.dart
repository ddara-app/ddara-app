/// 사이클 갤러리에서 멤버 사진 카드가 갖는 상태. (서버 `status` 문자열)
///
/// 잠금([locked])은 뷰어 맥락(내가 스타터인지·이미 올렸는지)을 서버가 판정해
/// 내려준다. 잠긴 카드에도 `imageUrl`·`shotId` 가 함께 오므로, 블러 처리한 채로
/// 크게 보기와 댓글에는 들어갈 수 있다. (2026-07-26 확인)
enum CycleShotStatus {
  /// 공개. 사진을 그대로 보여준다.
  open('open'),

  /// 미업로드. 보여줄 사진이 없다.
  empty('empty'),

  /// 잠금. 사진을 블러 + 자물쇠로 가린다.
  locked('locked'),

  /// 신고 접수로 검토 중. 사진 대신 안내 자리표시를 보여준다.
  reported('reported');

  const CycleShotStatus(this.value);

  /// 서버가 내려주는 문자열.
  final String value;

  /// 서버 응답 문자열을 enum 으로 변환한다.
  /// 모르는 값은 공개([open])로 본다 — 새 상태가 생겨도 카드가 사라지지 않도록.
  static CycleShotStatus from(String? value) {
    final normalized = value?.toLowerCase();
    for (final status in CycleShotStatus.values) {
      if (status.value == normalized) return status;
    }
    return CycleShotStatus.open;
  }
}
