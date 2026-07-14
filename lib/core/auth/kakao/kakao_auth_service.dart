import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoAuthService {
  // 카카오 로그인
  Future<void> signInWithKakao(
    Function(String) login,
    Function(String) errorFunc,
  ) async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        login(token.accessToken);
      } catch (error) {
        errorFunc('$error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          login(token.accessToken);
        } catch (_) {
          // 로그인 실패 — 위에서 errorFunc 로 이미 안내했으므로 추가 처리 없음.
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        login(token.accessToken);
      } catch (_) {
        // 로그인 실패 — 사용자가 취소한 경우 포함. 상태 변화 없이 종료한다.
      }
    }
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
