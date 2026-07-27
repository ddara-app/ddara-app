import 'package:ddara/core/design_system/component/button/app_button.dart';
import 'package:ddara/core/design_system/component/divider/app_divider.dart';
import 'package:ddara/core/design_system/component/icon/app_icon.dart';
import 'package:ddara/core/design_system/component/surface/app_surface.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/design_system/component/checkbox/app_checkbox.dart';
import 'package:ddara/core/widget/title_description.dart';
import 'package:ddara/core/widget/policy/policy_viewer_page.dart';
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

  /// 전체 동의 행. (체크박스·라벨을 포함한 영역 전체가 토글)
  ///
  /// 개별 약관 행([_TermItem])과 달리 상세보기('>')가 없고, 라벨이 강조된다.
  Widget _agreeAll(AppLocalizations l10n) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      alignment: Alignment.centerLeft,
      onPressed: () => _toggleAll(!_allAgreed),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppSpacing.s4,
          children: [
            AppCheckbox(value: _allAgreed, onChanged: _toggleAll, size: 20),
            Expanded(
              child: AppText.label(
                l10n.termsAgreeAll,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 페이지 여백은 SignUpPage 가 준다. (이 위젯은 본문만 그린다)
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 콘텐츠
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s7,
            children: [
              // 헤더
              TitleDescription(
                title: l10n.termsTitle,
                description: l10n.termsSubtitle,
              ),

              // 동의 목록 카드
              AppSurface(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s5,
                  vertical: AppSpacing.s2,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _agreeAll(l10n),

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 체크박스·라벨 영역 전체가 체크 토글 ('>' 영역은 제외).
        Expanded(
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            onPressed: () => onChanged(!value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: AppSpacing.s4,
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
            // 버튼 영역이 카드 안쪽 여백 끝에 붙는다. (아이콘은 그 안에서 중앙)
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s5),
            onPressed: onDetailTap,
            child: const AppIcon(
              AppIcons.chevronForward,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}
