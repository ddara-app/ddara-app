import 'dart:io';

import 'package:ddara/core/deeplink/pending_invite.dart';
import 'package:ddara/core/designsystem/component/button/app_text_button.dart';
import 'package:ddara/core/designsystem/component/loading/app_loading_overlay.dart';
import 'package:ddara/core/designsystem/component/logo.dart';
import 'package:ddara/core/designsystem/component/text/app_text.dart';
import 'package:ddara/core/designsystem/design_system.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/sign/login/provider/notifier_provider.dart';
import 'package:ddara/feature/sign/login/util/login_state.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(loginNotifierProvider.notifier);
    final isLoading = ref.watch(loginNotifierProvider) is LoginLoading;

    ref.listen(loginNotifierProvider, (previous, next) {
      switch (next) {
        case LoginSuccess():
          // 보관된 초대코드가 있으면 모임 참여로 복귀, 없으면 홈으로.
          routeAfterAuth(ref, GoRouter.of(context));

        case SignupRequired():
          context.push(RoutePath.signup, extra: next.social);

        case LoginFail(message: final message):
          Toast.showToast(context, message, type: ToastType.error);

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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
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
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.s3,
                    children: [
                      _SocialLoginButton(
                        label: l10n.loginKakao,
                        iconPath: 'assets/images/ic_kakao.svg',
                        backgroundColor: const Color(0xFFFEE500),
                        foregroundColor: const Color(0xFF000000),
                        onPressed: isLoading
                            ? null
                            : () => notifier.socialLogin(
                                context,
                                SocialLoginType.kakao,
                              ),
                      ),
                      _SocialLoginButton(
                        label: l10n.loginGoogle,
                        iconPath: 'assets/images/ic_google.svg',
                        backgroundColor: AppColors.textPrimary,
                        foregroundColor: const Color(0xFF000000),
                        onPressed: isLoading
                            ? null
                            : () => notifier.socialLogin(
                                context,
                                SocialLoginType.google,
                              ),
                      ),
                      // 애플 로그인은 iOS 에서만 노출한다. (안드로이드는 미지원)
                      if (Platform.isIOS)
                        _SocialLoginButton(
                          label: l10n.loginApple,
                          iconPath: 'assets/images/ic_apple_logo_.svg',
                          backgroundColor: const Color(0xFFFFFFFF),
                          foregroundColor: const Color(0xFF000000),
                          onPressed: isLoading
                              ? null
                              : () => notifier.socialLogin(
                                  context,
                                  SocialLoginType.apple,
                                ),
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

/// 소셜 로그인 버튼. (브랜드 색 기반 · 전체폭 · 좌측 브랜드 아이콘)
class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.label,
    required this.iconPath,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  /// 브랜드 아이콘 한 변 크기.
  static const double _iconSize = 20;

  final String label;

  /// 좌측에 표시할 브랜드 아이콘 SVG 에셋 경로.
  final String iconPath;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onPressed: onPressed,
      // 아이콘은 왼쪽 끝(버튼 패딩 16 안쪽)에 고정, 라벨은 버튼 정중앙.
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: _iconSize, height: _iconSize),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.16,
              ),
            ),
          ),
          // 아이콘 폭만큼 우측을 비워 라벨이 버튼 정중앙에 오도록 보정.
          const SizedBox(width: _iconSize),
        ],
      ),
    );
  }
}
