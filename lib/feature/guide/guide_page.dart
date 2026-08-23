import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/scrollable_page_body.dart';
import 'package:ddara/feature/guide/widget/guide_feature_cards.dart';
import 'package:ddara/feature/guide/widget/guide_flow_steps.dart';
import 'package:ddara/feature/guide/widget/guide_section.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 따라찍기 사용법 안내 화면.
///
/// 홈 '따라찍기 모임' 탭 대시보드의 가이드 페이지와, 따라찍기 촬영 화면
/// AppBar 의 도움말(?) 버튼 두 곳에서 들어온다.
class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.guidePageTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        child: ScrollablePageBody(
          // 상단 s6 · 좌우 s5. 하단은 페이지 표준(s7)을 그대로 쓴다.
          // (Safe Area 인셋은 ScrollablePageBody 가 여기에 더한다)
          padding: const EdgeInsets.only(
            top: AppSpacing.s6,
            left: AppSpacing.s5,
            right: AppSpacing.s5,
            bottom: AppSpacing.s7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // 섹션 사이 간격.
            spacing: AppSpacing.s8,
            children: [
              GuideSection(
                title: l10n.guideFlowTitle,
                child: const GuideFlowSteps(),
              ),
              GuideSection(
                title: l10n.guideFeatureTitle,
                child: const GuideFeatureCards(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
