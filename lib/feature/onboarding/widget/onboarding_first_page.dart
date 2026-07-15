import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// 온보딩 1페이지의 스와이프 콘텐츠 (제목 + 설명).
///
/// 로고·인디케이터는 [OnboardingPage] 가 고정으로 들고 있고,
/// 이 위젯만 PageView 안에서 좌우로 전환된다.
class OnboardingFirstPage extends StatelessWidget {
  const OnboardingFirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: TitleDescription(
        title: l10n.onboardingFirstTitle,
        description: l10n.onboardingFirstBody,
        centered: true,
      ),
    );
  }
}
