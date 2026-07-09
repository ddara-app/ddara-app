import 'dart:io';

import 'package:ddara/core/auth/apple_auth_service.dart';
import 'package:ddara/core/exception/profile_exception.dart';
import 'package:ddara/core/auth/google_auth_service.dart';
import 'package:ddara/core/auth/kakao_auth_service.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/domain/repository/auth_repository.dart';
import 'package:ddara/domain/repository/profile_repository.dart';

class DeleteAccountUseCase {
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;
  final KakaoAuthService _kakaoAuthService;
  final GoogleAuthService _googleAuthService;
  final AppleAuthService _appleAuthService;

  DeleteAccountUseCase(
    this._profileRepository,
    this._authRepository,
    this._kakaoAuthService,
    this._googleAuthService,
    this._appleAuthService,
  );

  /// 회원 탈퇴. 서버 탈퇴 후 소셜 SDK·로컬 인증 정보를 정리한다.
  ///
  /// 애플 계정(iOS)은 서버가 애플 연동 해제(token revoke)를 할 수 있도록
  /// 탈퇴 전에 애플 재인증을 한 번 더 거쳐 authorizationCode 를 함께 보낸다.
  /// 사용자가 재인증을 취소하면 아무 변경 없이 false 를 반환한다. (탈퇴 중단)
  ///
  /// 서버 탈퇴가 실패하면 예외가 전파되며, 이 경우 로컬 정보는 정리되지 않는다.
  /// (예외 처리는 호출부(Notifier)에서 담당한다)
  Future<bool> call() async {
    final social = await _authRepository.getSocialLoginType();

    // 애플(iOS): 연동 해제용 재인증. 취소하면 탈퇴 전체를 중단한다.
    // (안드로이드는 재인증 수단이 없어 코드 없이 탈퇴만 진행한다)
    String? appleAuthorizationCode;
    if (social == SocialLoginType.apple && Platform.isIOS) {
      appleAuthorizationCode = await _appleAuthService
          .getAuthorizationCodeForRevoke();
      if (appleAuthorizationCode == null) return false;
    }

    // 서버 탈퇴 실패 시 예외가 전파되어 아래 로컬 정리는 실행되지 않는다.
    try {
      await _profileRepository.deleteAccount(
        appleAuthorizationCode: appleAuthorizationCode,
      );
    } on UserNotFoundException {
      // 404 — 이미 탈퇴한 계정. 서버에는 지울 것이 없으므로 성공과 동일하게
      // 로컬 정리를 계속 진행한다. (멱등 처리 — 로컬 세션만 남은 상태 구제)
    }

    // 소셜 SDK 세션 정리.
    await _socialLogout(social);

    // 로컬 인증 정보 정리.
    await _authRepository.saveAccessToken(null);
    await _authRepository.saveRefreshToken(null);
    await _authRepository.deleteSocialLoginType();

    return true;
  }

  /// 소셜 종류에 맞춰 해당 SDK 로그아웃을 호출한다.
  Future<void> _socialLogout(SocialLoginType? social) async {
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
