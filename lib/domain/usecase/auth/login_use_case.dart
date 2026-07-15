import 'package:ddara/core/model/auth/login.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Login> call(String token, SocialLoginType social) async {
    final login = await _authRepository.login(token, social);

    if (!login.isNewUser) {
      await _authRepository.saveAccessToken(login.accessToken);
      await _authRepository.saveRefreshToken(login.refreshToken);
      // 토큰 만료 시 무중단 재인증에서 분기하도록 소셜 종류도 저장.
      await _authRepository.saveSocialLoginType(social);
    }

    return login;
  }
}
