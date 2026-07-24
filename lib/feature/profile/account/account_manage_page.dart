import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/util/tap_guard.dart';
import 'package:ddara/core/widget/dialog/app_dialog.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/profile/provider/notifier_provider.dart';
import 'package:ddara/feature/profile/util/profile_state.dart';
import 'package:ddara/feature/profile/widget/profile_section.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 계정 관리 화면. (프로필 → 계정 관리)
///
/// 연동 계정 정보와 로그아웃·회원 탈퇴 액션을 모아 보여준다.
/// 파괴적 액션을 프로필 화면에서 한 단계 안쪽으로 분리해, 프로필을 가볍게
/// 유지하면서 실수로 누를 가능성을 줄인다.
class AccountManagePage extends ConsumerWidget {
  const AccountManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(profileNotifierProvider);

    // 로그아웃 결과에 따라 분기: 성공 시 로그인 화면으로 이동, 실패 시 안내.
    ref.listen(profileNotifierProvider.select((s) => s.logoutStatus), (
      _,
      status,
    ) {
      if (!context.mounted) return;
      switch (status) {
        case LogoutStatus.success:
          MixpanelManager.instance.track('logout_succeeded');
          context.go(RoutePath.login);
        case LogoutStatus.fail:
          Toast.showToast(
            context,
            l10n.profileLogoutFailed,
            type: ToastType.error,
          );
        case LogoutStatus.idle:
        case LogoutStatus.loading:
          break;
      }
    });

    // 회원 탈퇴 결과에 따라 분기: 성공 시 로그인 화면으로 이동, 실패 시 안내.
    ref.listen(profileNotifierProvider.select((s) => s.withdrawStatus), (
      _,
      status,
    ) {
      if (!context.mounted) return;
      switch (status) {
        case WithdrawStatus.success:
          MixpanelManager.instance.track('account_withdraw_succeeded');
          context.go(RoutePath.login);
        case WithdrawStatus.fail:
          Toast.showToast(
            context,
            l10n.profileWithdrawFailed,
            type: ToastType.error,
          );
        case WithdrawStatus.idle:
        case WithdrawStatus.loading:
          break;
      }
    });

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.profileAccountManage,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          // 콘텐츠가 화면에 들어가면 스크롤 없음, 큰 글자 설정 등에서는
          // 스크롤로 전환되도록 뷰포트 높이를 최소 높이로 강제한다.
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.s3,
                  left: AppSpacing.s4,
                  right: AppSpacing.s4,
                  // 하단 Safe Area 까지 배경을 잇되, 마지막 항목이 홈
                  // 인디케이터와 겹치지 않도록 인셋만큼 더 띄운다.
                  bottom: AppSpacing.s6 + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProfileSection(
                      label: l10n.profileSectionAccount,
                      children: [
                        ProfileRow(
                          label: l10n.profileLinkedAccount,
                          // 이 화면은 프로필(로드 완료) 화면에서만 진입하지만,
                          // 타입상 로드 전이면 빈 값으로 표시한다.
                          value: switch (state.load) {
                            final ProfileLoaded loaded => loaded.linkedAccount,
                            _ => '',
                          },
                        ),
                        ProfileRow(
                          label: l10n.profileLogout,
                          // 로그아웃·탈퇴 중엔 두 행 모두 차단한다. (교차 실행 방지)
                          onTap: tapGuard(
                            _isAccountActionRunning(state),
                            () => _confirmLogout(context, ref),
                          ),
                        ),
                        ProfileRow(
                          label: l10n.profileWithdraw,
                          onTap: tapGuard(
                            _isAccountActionRunning(state),
                            () => _confirmWithdraw(context, ref),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 로그아웃 또는 회원 탈퇴 요청이 진행 중인지.
  bool _isAccountActionRunning(ProfileState state) =>
      state.logoutStatus == LogoutStatus.loading ||
      state.withdrawStatus == WithdrawStatus.loading;

  /// 로그아웃 확인 다이얼로그를 띄우고, 확인 시에만 로그아웃을 진행한다.
  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await AppDialog.show(
      context,
      title: l10n.profileLogoutConfirmTitle,
      confirmLabel: l10n.profileLogout,
    );
    if (ok) await ref.read(profileNotifierProvider.notifier).logout();
  }

  /// 회원 탈퇴 확인 다이얼로그를 띄우고, 확인 시에만 탈퇴를 진행한다.
  Future<void> _confirmWithdraw(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await AppDialog.show(
      context,
      title: l10n.profileWithdrawConfirmTitle,
      confirmLabel: l10n.profileWithdrawConfirmAction,
      confirmColor: AppColors.statusDanger,
      confirmLabelColor: AppColors.textPrimary,
    );
    if (ok) await ref.read(profileNotifierProvider.notifier).withdraw();
  }
}
