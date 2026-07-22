import 'package:ddara/core/exception/sign_up_exception.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/sign/signup/util/sign_up_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignNotifier
    extends AutoDisposeFamilyNotifier<SignUpPageState, SocialLoginType> {
  @override
  SignUpPageState build(SocialLoginType social) {
    return SignUpPageState(social: social);
  }

  void termsAgreedChanged(bool agreed) {
    state = state.copyWith(termsAgreed: agreed);
  }

  Future<void> signUp() async {
    // 처리 중 재진입(중복 제출) 방지.
    if (state.isLoading) return;

    // 새 제출 시작 시 이전 에러를 지운다. (성공/실패 결과는 아래에서 채운다)
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await ref.read(signUpUseCaseProvider)(state.social, state.termsAgreed);

      state = state.copyWith(isSuccess: true);
    } on TypeMisMatchException {
      state = state.copyWith(error: SignUpErrorType.invalidInput);
    } on UnauthorizedTokenException {
      state = state.copyWith(error: SignUpErrorType.invalidToken);
    } on UnsupportedProviderException {
      state = state.copyWith(error: SignUpErrorType.unsupportedProvider);
    } finally {
      // 로딩만 내린다. error 를 여기서 지우면 catch 가 채운 사유가 사라진다.
      state = state.copyWith(isLoading: false);
    }
  }
}
