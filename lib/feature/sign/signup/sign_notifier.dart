import 'package:ddara/core/auth/provider/auth_provider.dart';
import 'package:ddara/core/exception/sign_up_exception.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/sign/signup/util/sign_up_page_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignNotifier extends FamilyNotifier<SignUpPageState, SocialLoginType> {
  @override
  SignUpPageState build(SocialLoginType social) {
    return SignUpPageState(social: social);
  }

  void termsAgreedChanged(bool agreed) {
    state = state.copyWith(termsAgreed: agreed);
  }

  Future<void> signUp(BuildContext context) async {
    // 처리 중 재진입(중복 제출) 방지.
    if (state.isLoading) return;

    // 새 제출 시작 시 이전 에러를 지운다. (성공/실패 결과는 아래에서 채운다)
    state = state.copyWith(isLoading: true, errorMessage: "");

    // 임시 디버그: 애플 가입 시 서버로 넘길 Firebase ID Token 에 displayName 이
    // name 클레임으로 실렸는지 Toast 로 확인한다. getAppleIdToken() 은 캐시된
    // 현재 토큰을 반환하므로 아래 use case 가 서버로 보내는 토큰과 동일하다.
    // (확인 후 제거 예정)
    if (state.social == SocialLoginType.apple) {
      final appleAuthService = ref.read(appleAuthProvider);
      final idToken = await appleAuthService.getAppleIdToken();
      final nameClaim =
          idToken == null ? null : appleAuthService.debugNameClaimOf(idToken);
      if (context.mounted) {
        Toast.showToast(
          context,
          '[테스트] 가입 토큰 name 클레임: ${nameClaim ?? '(없음)'}',
          duration: const Duration(seconds: 8),
        );
      }
    }

    try {
      await ref.read(signUpUseCaseProvider)(state.social, state.termsAgreed);

      state = state.copyWith(isSuccess: true);
    } on TypeMisMatchException {
      state = state.copyWith(errorMessage: "입력값을 확인해 주세요.");
    } on UnauthorizedTokenException {
      state = state.copyWith(errorMessage: "소셜 토큰이 만료되었거나 유효하지 않습니다.");
    } on UnsupportedProviderException {
      state = state.copyWith(errorMessage: "지원하지 않는 로그인 방식입니다.");
    } finally {
      // 로딩만 내린다. errorMessage 를 여기서 지우면 catch 가 채운 메시지가 사라진다.
      state = state.copyWith(isLoading: false);
    }
  }
}
