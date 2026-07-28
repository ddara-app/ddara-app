/// Primitive 스페이싱 토큰 (Figma `Primitive` collection - spacing).
abstract final class AppSpacing {
  const AppSpacing._();

  // s1·s2 는 2·4 로 촘촘하고, s3 부터 4단위로 오른다.
  static const double s0 = 0;
  static const double s1 = 2;
  static const double s2 = 4;
  static const double s3 = 8;
  static const double s4 = 12;
  static const double s5 = 16;
  static const double s6 = 20;
  static const double s7 = 24;
  static const double s8 = 28;
  static const double s9 = 32;
  static const double s10 = 36;

  /// Pill 형태 등 완전히 채우는 간격.
  static const double full = 999;
}
