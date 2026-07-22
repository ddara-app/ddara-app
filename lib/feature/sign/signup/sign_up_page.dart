import 'package:ddara/core/analytics/mixpanel_manager.dart';
import 'package:ddara/core/router/pending_invite.dart';
import 'package:ddara/core/design_system/component/appbar/app_bar.dart';
import 'package:ddara/core/design_system/component/loading/app_loading_overlay.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/sign/signup/provider/notifier_provider.dart';
import 'package:ddara/feature/sign/signup/terms_page.dart';
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
    MixpanelManager.instance.track(
      'signup_page_viewed',
      properties: {'provider': social.name},
    );
  }

  @override
  Widget build(BuildContext context) {
    final social = GoRouterState.of(context).extra as SocialLoginType;
    final state = ref.watch(signNotifierProvider(social));
    final notifier = ref.read(signNotifierProvider(social).notifier);

    ref.listen(signNotifierProvider(social), (prev, next) {
      if (prev?.isSuccess == false && next.isSuccess) {
        MixpanelManager.instance.track(
          'signup_succeeded',
          properties: {'provider': social.name},
        );
        // 보관된 초대코드가 있으면 모임 참여로 복귀, 없으면 홈으로.
        routeAfterAuth(ref, GoRouter.of(context));
        return;
      }

      // errorMessage 가 새로 바뀐 경우에만 토스트. (finally 의 isLoading 갱신처럼
      // 같은 메시지로 상태가 재통지될 때 토스트가 중복되는 것을 막는다)
      final errorMessage = next.errorMessage;
      if (errorMessage.isNotEmpty && prev?.errorMessage != errorMessage) {
        Toast.showToast(context, errorMessage, type: ToastType.error);
      }
    });

    return CupertinoPageScaffold(
      navigationBar: AppBar(onBack: () => context.pop()),
      child: SafeArea(
        child: Stack(
          children: [
            // 약관 동의가 유일한 단계 → 동의 후 버튼을 누르면 바로 가입한다.
            // (닉네임·생일은 입력받지 않고, 닉네임은 소셜 프로필 이름으로 대체)
            TermsPage(
              initialAgreed: state.termsAgreed,
              onNextButtonClicked: notifier.signUp,
              onAgreementChanged: notifier.termsAgreedChanged,
            ),

            // 회원가입 처리 중 로딩 오버레이 (입력 차단 + 인디케이터)
            if (state.isLoading) const AppLoadingOverlay(),
          ],
        ),
      ),
    );
  }
}
