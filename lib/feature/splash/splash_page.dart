import 'package:ddara/core/design_system/component/logo/logo.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 앱 진입 스플래시 화면.
///
/// 네이티브(시스템) 스플래시는 단색 배경만 띄우고, 브랜드 로고·문구는 이 화면이
/// 담당한다. 상단 바 없이 로고와 태그라인만 화면 정중앙에 놓는다.
///
/// 네이티브 스플래시와 배경색이 같으므로, 로고를 투명도 0 에서 서서히 띄워
/// 단색 화면에서 자연스럽게 떠오르는 것처럼 보이게 한다.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  /// 로고·태그라인이 다 드러나기까지 걸리는 시간.
  /// (main 의 최소 노출 시간보다 짧아야 완성된 화면이 잠시라도 남는다)
  static const _fadeInDuration = Duration(milliseconds: 700);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: _fadeInDuration,
          curve: Curves.easeOut,
          builder: (_, opacity, child) =>
              Opacity(opacity: opacity, child: child),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s3,
            children: [
              const LogoLarge(),
              Text(
                l10n.splashTagline,
                style: AppTypography.label.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
