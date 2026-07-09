import 'package:ddara/core/designsystem/component/appbar/app_bar.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/profile/policy/policy_viewer_page.dart';
import 'package:ddara/feature/profile/widget/profile_section.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 약관 및 정책 화면.
class TermsPolicyPage extends StatelessWidget {
  const TermsPolicyPage({super.key});

  /// 약관 및 정책 목록에서 보여줄 문서들. (제목은 l10n 이라 build 시점에 구성)
  List<PolicyViewerArgs> _policies(AppLocalizations l10n) => [
    PolicyViewerArgs(
      title: l10n.policyTermsOfService,
      assetPath: 'assets/policy/terms_of_service.md',
    ),
    PolicyViewerArgs(
      title: l10n.policyPrivacy,
      assetPath: 'assets/policy/privacy_policy.md',
    ),
    PolicyViewerArgs(
      title: l10n.policyCommunityGuideline,
      assetPath: 'assets/policy/community_guideline.md',
    ),
    PolicyViewerArgs(
      title: l10n.policyYouthProtection,
      assetPath: 'assets/policy/youth_protection_policy.md',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.termsPolicyTitle,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: AppSpacing.s3,
            left: AppSpacing.s4,
            right: AppSpacing.s4,
            bottom: AppSpacing.s6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s5,
            children: [
              ProfileSection(
                label: l10n.termsPolicyTitle,
                children: [
                  for (final policy in _policies(l10n))
                    ProfileRow(
                      label: policy.title,
                      trailing: const ProfileChevron(),
                      onTap: () =>
                          context.push(RoutePath.policyViewer, extra: policy),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
