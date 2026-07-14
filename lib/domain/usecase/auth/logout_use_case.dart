import 'package:ddara/core/auth/apple/apple_auth_service.dart';
import 'package:ddara/core/auth/google/google_auth_service.dart';
import 'package:ddara/core/auth/kakao/kakao_auth_service.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';

import '../../repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;
  final KakaoAuthService _kakaoAuthService;
  final GoogleAuthService _googleAuthService;
  final AppleAuthService _appleAuthService;

  LogoutUseCase(
    this._authRepository,
    this._kakaoAuthService,
    this._googleAuthService,
    this._appleAuthService,
  );

  Future<bool> call() async {
    // 소셜 SDK 세션도 함께 정리. (저장된 소셜 종류 기준으로 분기)
    await _socialLogout();

    final refreshToken = await _authRepository.getRefreshToken();

    // refreshToken 이 없으면 서버 로그아웃은 건너뛰되, 로컬 정리는 수행한다.
    final logoutState = refreshToken == null
        ? true
        : await _authRepository.logOut(refreshToken);

    await _authRepository.saveAccessToken(null);
    await _authRepository.saveRefreshToken(null);
    await _authRepository.deleteSocialLoginType();

    return logoutState;
  }

  /// 저장된 소셜 종류에 맞춰 해당 SDK 로그아웃을 호출한다.
  Future<void> _socialLogout() async {
    final social = await _authRepository.getSocialLoginType();
    switch (social) {
      case SocialLoginType.kakao:
        await _kakaoAuthService.logout();
      case SocialLoginType.google:
        await _googleAuthService.signOut();
      case SocialLoginType.apple:
        await _appleAuthService.signOut();
      case null:
        // 소셜 종류 정보가 없으면 SDK 로그아웃은 생략.
        break;
    }
  }
}
