import 'package:ddara/core/analytics/analytics_events.dart';
import 'package:ddara/core/router/pending_invite.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/loading/app_loading_overlay.dart';
import 'package:ddara/core/design_system/foundation/app_spacing.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/sign/signup/provider/viewmodel_provider.dart';
import 'package:ddara/feature/sign/signup/terms_page.dart';
import 'package:ddara/feature/sign/signup/util/sign_up_page_state.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  /// 페이지 진입 이벤트는 한 번만 보낸다. (build 재호출로 중복 전송 방지)
  bool _pageViewTracked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pageViewTracked) return;
    _pageViewTracked = true;
    final social = GoRouterState.of(context).extra as SocialLoginType;
    AnalyticsEvents.signupPageViewed(social.name);
  }

  /// 실패 사유(enum)를 사용자 노출 문구로 매핑한다.
  String _signUpErrorMessage(AppLocalizations l10n, SignUpErrorType type) {
    return switch (type) {
      SignUpErrorType.invalidInput => l10n.signUpErrorInvalidInput,
      SignUpErrorType.invalidToken => l10n.signUpErrorInvalidToken,
      SignUpErrorType.unsupportedProvider =>
        l10n.signUpErrorUnsupportedProvider,
      SignUpErrorType.unknown => l10n.signUpErrorUnknown,
    };
  }

  @override
  Widget build(BuildContext context) {
    final social = GoRouterState.of(context).extra as SocialLoginType;
    final state = ref.watch(signViewModelProvider(social));
    final viewModel = ref.read(signViewModelProvider(social).notifier);

    ref.listen(signViewModelProvider(social), (prev, next) {
      // 제출 상태가 바뀐 경우만 처리. (termsAgreed 변경 같은 입력값 갱신으로
      // 같은 submit 이 재통지될 때 성공 라우팅·토스트가 중복되는 것을 막는다)
      if (prev?.submit == next.submit) return;

      switch (next.submit) {
        case SignUpSuccess():
          AnalyticsEvents.signupSucceeded(social.name);
          // 보관된 초대코드가 있으면 모임 참여로 복귀, 없으면 홈으로.
          routeAfterAuth(ref, GoRouter.of(context));

        case SignUpError(:final type):
          Toast.showToast(
            context,
            _signUpErrorMessage(AppLocalizations.of(context), type),
            type: ToastType.error,
          );

        default:
          break;
      }
    });

    return CupertinoPageScaffold(
      navigationBar: AppBar(onBack: () => context.pop()),
      child: SafeArea(
        child: Stack(
          children: [
            // 약관 동의가 유일한 단계 → 동의 후 버튼을 누르면 바로 가입한다.
            // (닉네임·생일은 입력받지 않고, 닉네임은 소셜 프로필 이름으로 대체)
            Padding(
              // 본문 여백. 좌우는 Page 규칙(s5), 하단은 버튼 아래 여백(s7).
              padding: const EdgeInsets.only(
                top: AppSpacing.s3,
                left: AppSpacing.s5,
                right: AppSpacing.s5,
                bottom: AppSpacing.s7,
              ),
              child: TermsPage(
                initialAgreed: state.termsAgreed,
                onNextButtonClicked: viewModel.signUp,
                onAgreementChanged: viewModel.termsAgreedChanged,
              ),
            ),

            // 회원가입 처리 중 로딩 오버레이 (입력 차단 + 인디케이터)
            if (state.submit is SignUpLoading) const AppLoadingOverlay(),
          ],
        ),
      ),
    );
  }
}
