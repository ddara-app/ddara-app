import 'package:ddara/core/auth/provider/auth_provider.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/feature/sign/login/util/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/exception/login_exception.dart';
import '../../../domain/provider/use_case_provider.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return Idle();
  }

  Future<void> socialLogin(SocialLoginType social) async {
    final googleAuthService = ref.read(googleAuthProvider);
    final kakaoAuthService = ref.read(kakaoAuthProvider);
    final appleAuthService = ref.read(appleAuthProvider);

    switch (social) {
      case SocialLoginType.google:
        googleAuthService.signInWithGoogle((token) => _login(token, social));
      case SocialLoginType.kakao:
        kakaoAuthService.signInWithKakao(
          (token) => _login(token, social),
          (message) => state = LoginFail(LoginErrorType.unknown, message),
        );
      case SocialLoginType.apple:
        try {
          final idToken = await appleAuthService.signInWithApple();
          // idToken 이 null 이면 사용자가 취소한 것 → 아무 처리도 하지 않는다.
          if (idToken != null) await _login(idToken, social);
        } catch (e) {
          state = LoginFail(LoginErrorType.unknown, '$e');
        }
    }
  }

  Future<void> _login(String token, SocialLoginType social) async {
    try {
      state = LoginLoading();

      final login = await ref.read(loginUseCaseProvider)(token, social);

      if (login.isNewUser) {
        state = SignupRequired(social);
      } else {
        state = LoginSuccess();
      }
    } on UnauthorizedException {
      state = LoginFail(LoginErrorType.unauthorized);
    } on NetworkException {
      state = LoginFail(LoginErrorType.network);
    }
  }
}
