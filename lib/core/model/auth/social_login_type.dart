enum SocialLoginType {
  google('GOOGLE', '구글'),
  kakao('KAKAO', '카카오'),
  apple('APPLE', '애플');

  const SocialLoginType(this.value, this.label);

  final String value;

  /// 화면에 노출할 한글 표시명. (예: '카카오')
  final String label;

  /// 저장된 문자열(`GOOGLE`/`KAKAO`)을 enum 으로 역매핑. 매칭 실패 시 null.
  static SocialLoginType? fromValue(String? value) {
    for (final type in SocialLoginType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}
