import 'dart:io';

import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:ddara/core/router/pending_invite.dart';
import 'package:ddara/core/design_system/component/button/app_text_button.dart';
import 'package:ddara/core/design_system/component/loading/app_loading_overlay.dart';
import 'package:ddara/core/design_system/component/logo/logo.dart';
import 'package:ddara/core/design_system/component/text/app_text.dart';
import 'package:ddara/core/design_system/design_system.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/sign/login/provider/notifier_provider.dart';
import 'package:ddara/feature/sign/login/util/login_state.dart';
import 'package:ddara/feature/sign/login/widget/social_login_button.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
    MixpanelManager.instance.track('login_page_viewed');
  }

  /// 실패 사유(enum)를 사용자 노출 문구로 매핑한다.
  String _loginErrorMessage(AppLocalizations l10n, LoginErrorType type) {
    return switch (type) {
      LoginErrorType.unauthorized => l10n.loginErrorUnauthorized,
      LoginErrorType.network => l10n.loginErrorNetwork,
      LoginErrorType.unknown => l10n.loginErrorUnknown,
    };
  }

  void _onSocialLogin(SocialLoginType type) {
    MixpanelManager.instance.track(
      'login_attempted',
      properties: {'provider': type.name},
    );
    ref.read(loginNotifierProvider.notifier).socialLogin(type);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 로딩 여부만 구독해 그 외 상태 변화(성공·실패 등)로 인한 rebuild 를 막는다.
    // (성공·실패 처리는 아래 ref.listen 이 담당)
    final isLoading = ref.watch(
      loginNotifierProvider.select((s) => s is LoginLoading),
    );

    ref.listen(loginNotifierProvider, (previous, next) {
      switch (next) {
        case LoginSuccess(:final social):
          MixpanelManager.instance.track(
            'login_succeeded',
            properties: {'provider': social.name},
          );
          // 보관된 초대코드가 있으면 모임 참여로 복귀, 없으면 홈으로.
          routeAfterAuth(ref, GoRouter.of(context));

        case SignupRequired():
          MixpanelManager.instance.track(
            'login_signup_required',
            properties: {'provider': next.social.name},
          );
          context.push(RoutePath.signup, extra: next.social);

        case LoginFail(:final social, :final type, :final debugMessage):
          MixpanelManager.instance.track(
            'login_failed',
            properties: {
              'provider': social.name,
              'reason': debugMessage ?? type.name,
            },
          );
          Toast.showToast(
            context,
            _loginErrorMessage(l10n, type),
            type: ToastType.error,
          );

        default:
          break;
      }
    });

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // 브랜딩 영역
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s5,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: AppSpacing.s2,
                      children: [
                        const LogoLarge(),
                        AppText.title(
                          l10n.loginSlogan,
                          textAlign: TextAlign.center,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),

                // 소셜 로그인 영역
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s5,
                    0,
                    AppSpacing.s5,
                    AppSpacing.s4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.s3,
                    children: [
                      SocialLoginButton(
                        label: l10n.loginKakao,
                        icon: AppIcons.kakao,
                        backgroundColor: AppColorPrimitives.kakaoYellow,
                        foregroundColor: AppColorPrimitives.pureBlack,
                        onPressed: isLoading
                            ? null
                            : () => _onSocialLogin(SocialLoginType.kakao),
                      ),
                      SocialLoginButton(
                        label: l10n.loginGoogle,
                        icon: AppIcons.google,
                        backgroundColor: AppColorPrimitives.white,
                        foregroundColor: AppColorPrimitives.pureBlack,
                        onPressed: isLoading
                            ? null
                            : () => _onSocialLogin(SocialLoginType.google),
                      ),
                      // 애플 로그인은 iOS 에서만 노출한다. (안드로이드는 미지원)
                      if (Platform.isIOS)
                        SocialLoginButton(
                          label: l10n.loginApple,
                          icon: AppIcons.apple,
                          backgroundColor: AppColorPrimitives.white,
                          foregroundColor: AppColorPrimitives.pureBlack,
                          onPressed: isLoading
                              ? null
                              : () => _onSocialLogin(SocialLoginType.apple),
                        ),
                      AppTextButton(
                        label: l10n.loginViewPolicies,
                        onPressed: () => context.push(RoutePath.termsPolicy),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 로그인 처리 중 로딩 오버레이 (입력 차단 + 인디케이터)
          if (isLoading) const AppLoadingOverlay(),
        ],
      ),
    );
  }
}
