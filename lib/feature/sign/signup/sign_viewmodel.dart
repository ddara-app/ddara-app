import 'package:ddara/core/exception/sign_up_exception.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/sign/signup/util/sign_up_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignViewModel
    extends AutoDisposeFamilyNotifier<SignUpPageState, SocialLoginType> {
  @override
  SignUpPageState build(SocialLoginType social) {
    return const SignUpPageState();
  }

  void termsAgreedChanged(bool agreed) {
    state = state.copyWith(termsAgreed: agreed);
  }

  Future<void> signUp() async {
    // 처리 중 재진입(중복 제출) 방지.
    if (state.submit is SignUpLoading) return;

    state = state.copyWith(submit: const SignUpLoading());

    try {
      await ref.read(signUpUseCaseProvider)(arg, state.termsAgreed);

      state = state.copyWith(submit: const SignUpSuccess());
    } on TypeMisMatchException {
      state = state.copyWith(
        submit: const SignUpError(SignUpErrorType.invalidInput),
      );
    } on UnauthorizedTokenException {
      state = state.copyWith(
        submit: const SignUpError(SignUpErrorType.invalidToken),
      );
    } on UnsupportedProviderException {
      state = state.copyWith(
        submit: const SignUpError(SignUpErrorType.unsupportedProvider),
      );
    } catch (_) {
      // 예상 밖 예외가 조용히 전파되어 사용자 피드백 없이 끝나는 것을
      // 방지하는 폴백.
      state = state.copyWith(submit: const SignUpError(SignUpErrorType.unknown));
    }
  }
}
