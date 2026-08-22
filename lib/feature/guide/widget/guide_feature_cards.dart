import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 카드 안 이미지의 가로:세로 비율. (Figma 158x112 = 79:56)
///
/// 폭을 고정하지 않고 비율만 유지한다. 시안 프레임(412) 에서는 158x112 그대로
/// 나오고, 더 좁은 화면에서는 카드 폭에 맞춰 함께 줄어든다.
const double _imageRatio = 158 / 112;

/// 촬영 보조 기능을 카드 두 장으로 나란히 소개한다.
///
/// 카드 폭은 화면에 맞춰 균등하게 나누고([Expanded]), 사이 간격만 s5 로 둔다.
/// 설명 줄 수가 달라져도 두 장의 높이가 어긋나지 않도록 세로로 늘려 맞춘다.
class GuideFeatureCards extends StatelessWidget {
  const GuideFeatureCards({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 스크롤 본문 안이라 Row 에 들어오는 최대 높이가 무한대다. 그대로
    // stretch 를 쓰면 카드가 무한 높이로 늘어나 레이아웃이 깨지므로,
    // IntrinsicHeight 로 '가장 높은 카드' 만큼 높이를 확정한 뒤 맞춘다.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s5,
        children: [
          Expanded(
            child: _FeatureCard(
              imagePath: 'assets/images/corner_guide.png',
              title: l10n.guideFeatureCornerTitle,
              description: l10n.guideFeatureCornerDescription,
            ),
          ),
          Expanded(
            child: _FeatureCard(
              imagePath: 'assets/images/ghost_guide.png',
              title: l10n.guideFeatureGhostTitle,
              description: l10n.guideFeatureGhostDescription,
            ),
          ),
        ],
      ),
    );
  }
}

/// 기능 카드 한 장. 이미지 · 기능 이름 · 설명 순으로 쌓는다.
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  /// 기능을 보여주는 이미지 에셋 경로. (원본 474x336 = 158x112 의 3배)
  final String imagePath;

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 이미지와 이름 사이 간격(s4). 아래 s2 와 달라 spacing 대신 패딩으로 둔다.
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: AspectRatio(
                aspectRatio: _imageRatio,
                // 에셋 비율이 _imageRatio 와 같아 cover 로도 잘리지 않는다.
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
          ),
          // label 기본색은 textSecondary 라 기능 이름용으로 올려 잡는다.
          AppText.label(title, color: AppColors.textPrimary),
          const SizedBox(height: AppSpacing.s2),
          AppText.caption(description),
        ],
      ),
    );
  }
}
