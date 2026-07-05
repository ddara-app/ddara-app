import 'package:ddara/core/auth/apple_auth_service.dart';
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
  /// 서버 탈퇴가 실패하면 예외가 전파되며, 이 경우 로컬 정보는 정리되지 않는다.
  /// (예외 처리는 호출부(Notifier)에서 담당한다)
  Future<void> call() async {
    // 서버 탈퇴 실패 시 예외가 전파되어 아래 로컬 정리는 실행되지 않는다.
    await _profileRepository.deleteAccount();

    // 소셜 SDK 세션 정리. (저장된 소셜 종류 기준으로 분기 — 삭제 전에 조회)
    await _socialLogout();

    // 로컬 인증 정보 정리.
    await _authRepository.saveAccessToken(null);
    await _authRepository.saveRefreshToken(null);
    await _authRepository.deleteSocialLoginType();
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
