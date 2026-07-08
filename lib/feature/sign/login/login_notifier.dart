import 'package:ddara/core/auth/provider/auth_provider.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/core/widget/toast/toast.dart';
import 'package:ddara/feature/sign/login/util/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/exception/login_exception.dart';
import '../../../domain/provider/use_case_provider.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return Idle();
  }

  Future<void> socialLogin(BuildContext context, SocialLoginType social) async {
    final googleAuthService = ref.read(googleAuthProvider);
    final kakaoAuthService = ref.read(kakaoAuthProvider);
    final appleAuthService = ref.read(appleAuthProvider);

    switch (social) {
      case SocialLoginType.google:
        googleAuthService.signInWithGoogle(
          context,
          (token) => _login(token, social),
        );
      case SocialLoginType.kakao:
        kakaoAuthService.signInWithKakao(
          (token) => _login(token, social),
          (message) => state = LoginFail(message),
        );
      case SocialLoginType.apple:
        try {
          final idToken = await appleAuthService.signInWithApple();
          // idToken 이 null 이면 사용자가 취소한 것 → 아무 처리도 하지 않는다.
          if (idToken != null) await _login(idToken, social);
        } catch (e) {
          // 임시 디버그: 진단 메시지를 캡처할 수 있게 Toast 로 길게 노출한다.
          if (context.mounted) {
            Toast.showToast(
              context,
              '애플 로그인 실패\n$e',
              type: ToastType.error,
              duration: const Duration(seconds: 12),
            );
          }
          state = LoginFail('$e');
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
      state = LoginFail('Unauthorized');
    } on NetworkException {
      state = LoginFail('Network error');
    }
  }
}
