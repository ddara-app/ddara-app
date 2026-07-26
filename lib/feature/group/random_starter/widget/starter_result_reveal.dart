import 'package:ddara/core/design_system/component/avatar/profile_avatar.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/group/group_detail.dart';
import 'package:ddara/feature/group/random_starter/util/starter_reel.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// 슬롯이 사라진 자리에서 떠오르는 스타터 결과 리빌. (큰 아바타 + 안내 문구)
///
/// [scale] 은 easeOutBack 이라 1.0 을 살짝 넘겼다 정착 — 아바타가 "톡
/// 튀어나오는" 오버슈트를 낸다. (신나지만 가볍게, 트로피 시상대급은 아님)
class StarterResultReveal extends StatelessWidget {
  const StarterResultReveal({
    super.key,
    required this.starter,
    required this.opacity,
    required this.scale,
  });

  /// 공개할 스타터.
  final GroupMember starter;

  /// 등장 불투명도. (0→1, easeOut)
  final Animation<double> opacity;

  /// 등장 스케일. (0.7→1, easeOutBack 오버슈트 포함)
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FadeTransition(
      opacity: opacity,
      child: ScaleTransition(
        scale: scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileAvatar(
              size: StarterReelLayout.itemHeight,
              imageUrl: starter.profileImageUrl,
            ),
            const SizedBox(height: AppSpacing.s4),
            AppText.headlineLarge(
              l10n.randomStarterResultTitle(starter.nickname),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s1),
            AppText.body(
              l10n.randomStarterResultSubtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
