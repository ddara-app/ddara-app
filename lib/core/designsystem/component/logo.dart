import 'package:ddara/core/designsystem/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

/// 앱 브랜드 로고 텍스트 (`ddara.`).
///
/// 어디서든 가져다 쓰는 재사용 위젯.
/// 크기 20 · 굵기 700(bold) · Pretendard · 행간 140% · 자간 -1%.
/// 기본 색은 [AppColors.textPrimary].
class Logo extends StatelessWidget {
  const Logo({super.key, this.color = AppColors.textPrimary});

  /// 로고 색. (기본: 다크 테마용 텍스트 기본색)
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'ddara.',
      style: TextStyle(
        color: color,
        fontSize: 20,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 20 * -0.01,
      ),
    );
  }
}

/// Splash·온보딩용 대형 브랜드 로고 (`ddara.`).
///
/// Poppins · 크기 46 · 굵기 600(SemiBold) · 행간 100% · 자간 0%.
/// 기본 색은 [AppColors.textPrimary].
class LogoLarge extends StatelessWidget {
  const LogoLarge({super.key, this.color = AppColors.textPrimary});

  /// 로고 색. (기본: 다크 테마용 텍스트 기본색)
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'ddara.',
      style: TextStyle(
        color: color,
        fontSize: 46,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        height: 1.0,
        letterSpacing: 0,
      ),
    );
  }
}
