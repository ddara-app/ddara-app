import 'package:ddara/core/designsystem/component/button/app_button.dart';
import 'package:ddara/core/designsystem/component/divider/app_divider.dart';
import 'package:ddara/core/designsystem/component/surface/app_surface.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/app_checkbox.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/feature/profile/policy/policy_viewer_page.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class TermsPage extends StatefulWidget {
  final VoidCallback onNextButtonClicked;

  /// 필수 약관 전체 동의 여부가 바뀔 때 호출. (둘 다 동의해야 true)
  final ValueChanged<bool> onAgreementChanged;

  /// 뒤로가기로 다시 들어왔을 때 복원할 기존 동의 상태.
  final bool initialAgreed;

  const TermsPage({
    super.key,
    required this.onNextButtonClicked,
    required this.onAgreementChanged,
    this.initialAgreed = false,
  });

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  late bool _termsOfService = widget.initialAgreed;
  late bool _privacyPolicy = widget.initialAgreed;
  late bool _ageOver14 = widget.initialAgreed;

  bool get _allAgreed => _termsOfService && _privacyPolicy && _ageOver14;

  void _notify() => widget.onAgreementChanged(_allAgreed);

  void _toggleAll(bool value) {
    setState(() {
      _termsOfService = value;
      _privacyPolicy = value;
      _ageOver14 = value;
    });
    _notify();
  }

  void _toggleTermsOfService(bool value) {
    setState(() => _termsOfService = value);
    _notify();
  }

  void _togglePrivacyPolicy(bool value) {
    setState(() => _privacyPolicy = value);
    _notify();
  }

  void _toggleAgeOver14(bool value) {
    setState(() => _ageOver14 = value);
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 콘텐츠
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              // 헤더
              TitleDescription(
                title: l10n.termsTitle,
                description: l10n.termsSubtitle,
              ),

              // 동의 목록 카드
              AppSurface(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 전체 동의 (영역 전체가 토글)
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      onPressed: () => _toggleAll(!_allAgreed),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 12,
                          children: [
                            AppCheckbox(
                              value: _allAgreed,
                              onChanged: _toggleAll,
                              size: 22,
                            ),
                            Expanded(
                              child: AppText.label(
                                l10n.termsAgreeAll,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 구분선
                    const AppDivider(),

                    // [필수] 이용약관
                    _TermItem(
                      label: l10n.termsServiceLabel,
                      value: _termsOfService,
                      onChanged: _toggleTermsOfService,
                      onDetailTap: () => context.push(
                        RoutePath.policyViewer,
                        extra: PolicyViewerArgs(
                          title: l10n.policyServiceTitle,
                          assetPath: 'assets/policy/terms_of_service.md',
                        ),
                      ),
                    ),

                    // [필수] 개인정보 처리방침
                    _TermItem(
                      label: l10n.termsPrivacyLabel,
                      value: _privacyPolicy,
                      onChanged: _togglePrivacyPolicy,
                      onDetailTap: () => context.push(
                        RoutePath.policyViewer,
                        extra: PolicyViewerArgs(
                          title: l10n.policyPrivacyTitle,
                          assetPath: 'assets/policy/privacy_policy.md',
                        ),
                      ),
                    ),

                    // [필수] 만 14세 이상 사용자 이용동의
                    _TermItem(
                      label: l10n.termsAgeLabel,
                      value: _ageOver14,
                      onChanged: _toggleAgeOver14,
                      onDetailTap: () => context.push(
                        RoutePath.policyViewer,
                        extra: PolicyViewerArgs(
                          title: l10n.policyYouthTitle,
                          assetPath: 'assets/policy/youth_protection_policy.md',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          // 하단 버튼 (필수 약관 전체 동의 시에만 활성화)
          AppButton(
            label: l10n.termsContinueButton,
            onPressed: _allAgreed ? widget.onNextButtonClicked : null,
          ),
        ],
      ),
    );
  }
}

/// 개별 필수 약관 항목. (체크박스 · 라벨 · 상세보기 아이콘)
///
/// 체크박스·라벨 영역을 누르면 동의 여부가 토글되고, 우측 '>' 를 누르면
/// [onDetailTap] 으로 약관 내용 페이지를 연다. [onDetailTap] 이 null 이면
/// 상세 문서가 없는 항목으로 보고 '>' 를 표시하지 않는다.
class _TermItem extends StatelessWidget {
  const _TermItem({
    required this.label,
    required this.value,
    required this.onChanged,
    this.onDetailTap,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  /// 상세보기('>') 탭 콜백. null 이면 '>' 를 숨긴다.
  final VoidCallback? onDetailTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 체크박스·라벨 영역 전체가 체크 토글 ('>' 영역은 제외).
        Expanded(
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            onPressed: () => onChanged(!value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  AppCheckbox(value: value, onChanged: onChanged),
                  Expanded(child: AppText.body(label)),
                ],
              ),
            ),
          ),
        ),

        // 약관 상세보기. 탭 시 약관 내용 페이지로 이동.
        if (onDetailTap != null)
          CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            onPressed: onDetailTap,
            child: const Icon(
              CupertinoIcons.chevron_forward,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}
