import 'dart:async';

import 'package:ddara/core/analytics/crashlytics_manager.dart';
import 'package:ddara/core/auth/social_auth_result.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoAuthService {
  // 카카오 로그인
  Future<SocialAuthResult> signInWithKakao() async {
    if (!await isKakaoTalkInstalled()) {
      return _signInWithKakaoAccount();
    }

    try {
      final token = await UserApi.instance.loginWithKakaoTalk();
      return SocialAuthSuccess(token.accessToken);
    } catch (error) {
      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 취소로 처리 (예: 뒤로 가기)
      if (_isCancelled(error)) return const SocialAuthCancelled();

      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      return _signInWithKakaoAccount();
    }
  }

  /// 카카오계정(웹) 로그인.
  Future<SocialAuthResult> _signInWithKakaoAccount() async {
    try {
      final token = await UserApi.instance.loginWithKakaoAccount();
      return SocialAuthSuccess(token.accessToken);
    } catch (error, stack) {
      if (_isCancelled(error)) return const SocialAuthCancelled();

      // 취소가 아닌 실패만 남긴다. 카카오계정 로그인은 마지막 수단이라
      // 여기서 실패하면 사용자가 앱에 들어올 방법이 없다.
      unawaited(
        CrashlyticsManager.instance.recordError(
          error,
          stack,
          reason: 'kakao account sign-in failed',
        ),
      );
      return SocialAuthFailure('$error');
    }
  }

  /// 사용자의 의도적인 로그인 취소인지 판별한다.
  /// (카카오톡 앱 뒤로 가기 · 계정 로그인 웹 화면에서 동의 거부/닫기)
  bool _isCancelled(Object error) {
    if (error is PlatformException && error.code == 'CANCELED') return true;
    if (error is KakaoAuthException &&
        error.error == AuthErrorCause.accessDenied) {
      return true;
    }
    return false;
  }

  Future<String?> getKakaoAccessToken() async {
    try {
      final token = await TokenManagerProvider.instance.manager.getToken();
      return token?.accessToken;
    } catch (e) {
      return null;
    }
  }

  /// 카카오 프로필 닉네임을 가져온다. 실패하거나 동의항목이 없으면 null.
  /// (회원가입 시 소셜 프로필 이름으로 사용)
  Future<String?> getKakaoName() async {
    try {
      final user = await UserApi.instance.me();
      return user.kakaoAccount?.profile?.nickname;
    } catch (e) {
      return null;
    }
  }

  Future<bool> hasToken() async {
    return await AuthApi.instance.hasToken();
  }

  Future<bool> availabilityToken() async {
    try {
      await UserApi.instance.accessTokenInfo();
      return true;
    } catch (e) {
      return false;
    }
  }

  // 카카오 로그아웃 (토큰 만료 처리)
  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
    } catch (_) {
      // 이미 토큰이 없는 경우 등은 로그아웃된 것으로 간주.
    }
  }
}
