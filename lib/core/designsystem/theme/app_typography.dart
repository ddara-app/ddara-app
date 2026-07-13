import 'package:flutter/widgets.dart';

/// 타이포그래피 토큰 (Figma Type Scale · 7단계).
///
/// 다크 테마 기준. 폰트는 **Pretendard**.
///
/// 변환 규칙:
/// - `height`(배수)       = 행간%            (예: 125% → 1.25)
/// - `letterSpacing`(px) = fontSize × 자간%  (예: 32 × -2% = -0.64)
///
/// 패턴: 큰 글자일수록 자간을 좁히고(-2%), 작은 글자는 덜 좁힌다.
///
/// 굵기: Bold=w700 · SemiBold=w600 · Medium=w500 · Regular=w400.
abstract final class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'Pretendard';

  /// Display · 32 / Bold · 행간 125% · 자간 -2%
  /// 화면에 한 번만 쓰는 제일 큰 글자 (온보딩·연말 리포트 표지).
  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 32 * -0.02,
  );

  /// Headline/Large · 20 / Bold · 행간 140% · 자간 -1%
  /// 화면 진입 시 메인 제목 (헤더·모임 이름).
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.40,
    letterSpacing: 20 * -0.01,
  );

  /// Headline/Medium · 16 / Bold · 행간 150% · 자간 -1%
  /// 여러 줄 소제목 (넉넉한 행간).
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.50,
    letterSpacing: 16 * -0.01,
  );

  /// Title/Large · 20 / Medium · 행간 140% · 자간 -4%(-0.8px)
  /// 상단 바(AppBar) 제목.
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.40,
    letterSpacing: 20 * -0.04,
  );

  /// Title · 16 / Bold · 행간 150% · 자간 -1%
  /// 한 줄 카드·항목 제목.
  /// ⚠ 스펙상 150% 이나 "단행용 100%" 의도 표기됨 → 확정 필요.
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.50,
    letterSpacing: 16 * -0.01,
  );

  /// Label · 14 / SemiBold · 행간 135% · 자간 -2%
  /// 버튼·탭·칩에 들어가는 글자. (의도 SemiBold — 현재 임시 Medium 대체 표기)
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 14 * -0.02,
  );

  /// Body · 14 / Regular · 행간 155% · 자간 -1%
  /// 기본 본문 (메모·공동기록·회상 카드 글).
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
    letterSpacing: 14 * -0.01,
  );

  /// Caption · 12 / Regular · 행간 130% · 자간 -1%
  /// 제일 작은 글자 (시간·상태 표시).
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.30,
    letterSpacing: 12 * -0.01,
  );
}
