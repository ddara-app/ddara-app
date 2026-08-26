import 'package:ddara/core/auth/apple/apple_auth_service.dart';
import 'package:ddara/core/auth/google/google_auth_service.dart';
import 'package:ddara/core/auth/kakao/kakao_auth_service.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/domain/model/sign_up_command.dart';
import 'package:ddara/domain/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;
  final KakaoAuthService _kakaoAuthService;
  final GoogleAuthService _googleAuthService;
  final AppleAuthService _appleAuthService;

  SignUpUseCase(
    this._authRepository,
    this._kakaoAuthService,
    this._googleAuthService,
    this._appleAuthService,
  );

  Future<void> call(SocialLoginType loginType, bool termsAgreed) async {
    // 닉네임 입력 화면을 제거하고, 소셜 로그인 프로필 이름을 닉네임으로 사용한다.
    // 애플은 Firebase ID Token 을 재획득한다. (이름은 로그인 때 저장된 displayName
    // 이 토큰의 name 클레임으로 실려 오므로 백엔드가 그대로 사용한다)
    final token = switch (loginType) {
      SocialLoginType.kakao => await _kakaoAuthService.getKakaoAccessToken(),
      SocialLoginType.google => await _googleAuthService.getGoogleAccessToken(),
      SocialLoginType.apple => await _appleAuthService.getAppleIdToken(),
    };

    final signUpCommand = SignUpCommand(
      provider: loginType.value,
      accessToken: token!,
      termsAgreed: termsAgreed,
    );

    final response = await _authRepository.signUp(signUpCommand);

    await _authRepository.saveAccessToken(response.accessToken);
    await _authRepository.saveRefreshToken(response.refreshToken);
    // 토큰 만료 시 무중단 재인증에서 분기하도록 소셜 종류도 저장.
    await _authRepository.saveSocialLoginType(loginType);

    // 서버에 이름이 저장됐으므로 애플 이름/이메일 Keychain 백업은 삭제한다.
    if (loginType == SocialLoginType.apple) {
      await _appleAuthService.clearCredentialBackup();
    }
  }
}
