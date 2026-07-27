import 'package:ddara/core/analytics/app_analytics.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/widget/scrollable_page_body.dart';
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
      _onAccountActionResult(
        context,
        success: status == LogoutStatus.success,
        fail: status == LogoutStatus.fail,
        trackEvent: 'logout_succeeded',
        failMessage: l10n.profileLogoutFailed,
      );
    });

    // 회원 탈퇴 결과에 따라 분기: 성공 시 로그인 화면으로 이동, 실패 시 안내.
    ref.listen(profileNotifierProvider.select((s) => s.withdrawStatus), (
      _,
      status,
    ) {
      _onAccountActionResult(
        context,
        success: status == WithdrawStatus.success,
        fail: status == WithdrawStatus.fail,
        trackEvent: 'account_withdraw_succeeded',
        failMessage: l10n.profileWithdrawFailed,
      );
    });

    return CupertinoPageScaffold(
      navigationBar: AppBar(
        title: l10n.profileAccountManage,
        onBack: () => context.pop(),
      ),
      child: SafeArea(
        bottom: false,
        child: ScrollablePageBody(
          // 섹션이 하나뿐이라 Column 없이 폭만 채운다.
          child: SizedBox(
            width: double.infinity,
            child: ProfileSection(
              label: l10n.profileSectionAccount,
              children: [
                ProfileRow(
                  label: l10n.profileLinkedAccount,
                  // 이 화면은 프로필(로드 완료) 화면에서만 진입하지만,
                  // 타입상 로드 전이면 빈 값으로 표시한다.
                  value: switch (state.load) {
                    final ProfileLoaded loaded => loaded.provider?.label ?? '',
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
          ),
        ),
      ),
    );
  }

  /// 로그아웃 또는 회원 탈퇴 요청이 진행 중인지.
  bool _isAccountActionRunning(ProfileState state) =>
      state.logoutStatus == LogoutStatus.loading ||
      state.withdrawStatus == WithdrawStatus.loading;

  /// 로그아웃·회원 탈퇴 공통 결과 처리.
  /// 성공 시 이벤트를 기록하고 로그인 화면으로 이동, 실패 시 토스트를 띄운다.
  void _onAccountActionResult(
    BuildContext context, {
    required bool success,
    required bool fail,
    required String trackEvent,
    required String failMessage,
  }) {
    if (!context.mounted) return;
    if (success) {
      AppAnalytics.track(trackEvent);
      context.go(RoutePath.login);
    } else if (fail) {
      Toast.showToast(context, failMessage, type: ToastType.error);
    }
  }

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
