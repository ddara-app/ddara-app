import 'package:ddara/core/auth/provider/auth_provider.dart';
import 'package:ddara/core/auth/social_auth_result.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/feature/sign/login/util/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/exception/login_exception.dart';
import '../../../domain/provider/use_case_provider.dart';

class LoginViewModel extends AutoDisposeNotifier<LoginState> {
  @override
  LoginState build() {
    return const LoginIdle();
  }

  Future<void> socialLogin(SocialLoginType social) async {
    // OAuth 진행 중 재진입(다른 소셜 버튼·연타) 방지. SDK 인증 UI 가 뜨기 전
    // 공백에도 버튼이 잠기도록 진입 즉시 로딩으로 올린다.
    if (state is LoginLoading) return;
    state = LoginLoading(social);

    final result = await switch (social) {
      SocialLoginType.google => ref.read(googleAuthProvider).signInWithGoogle(),
      SocialLoginType.kakao => ref.read(kakaoAuthProvider).signInWithKakao(),
      SocialLoginType.apple => ref.read(appleAuthProvider).signInWithApple(),
    };

    switch (result) {
      case SocialAuthSuccess(:final token):
        await _login(token, social);
      case SocialAuthCancelled():
        state = const LoginIdle();
      case SocialAuthFailure(:final debugMessage):
        state = LoginFail(social, LoginErrorType.unknown, debugMessage);
    }
  }

  Future<void> _login(String token, SocialLoginType social) async {
    try {
      final login = await ref.read(loginUseCaseProvider)(token, social);

      if (login.isNewUser) {
        state = SignupRequired(social);
      } else {
        state = LoginSuccess(social);
      }
    } on UnauthorizedException {
      state = LoginFail(social, LoginErrorType.unauthorized);
    } on NetworkException {
      state = LoginFail(social, LoginErrorType.network);
    } catch (e) {
      // 예상 밖 예외(서버 5xx 매핑 예외·파싱 오류 등)로 LoginLoading 에
      // 고착되어 로딩 오버레이가 화면을 영구히 막는 것을 방지하는 폴백.
      state = LoginFail(social, LoginErrorType.unknown, '$e');
    }
  }
}
