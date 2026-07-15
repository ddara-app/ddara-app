import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/domain/model/sign_up_command.dart';

import '../../core/model/auth/login.dart';

abstract interface class AuthRepository {
  Future<Login> login(String token, SocialLoginType social);

  Future<Login> signUp(SignUpCommand signUp);

  Future<bool> logOut(String refreshToken);

  Future<void> saveAccessToken(String? token);

  Future<void> saveRefreshToken(String? token);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<String> refreshAccessToken(String refreshToken);

  /// 만료된 세션을 복구한다. (RefreshToken 재발급 → 실패 시 소셜 무중단 재인증)
  ///
  /// - 새 AccessToken: 복구 성공
  /// - `null`: 복구 불가(재로그인 필요)
  /// - 예외 전파: 일시적 오류(네트워크 등) → 강제 로그아웃하지 않음
  ///
  /// 동시 호출은 한 번만 수행하고 결과를 공유한다(단일 비행).
  Future<String?> recoverSession();

  Future<void> saveSocialLoginType(SocialLoginType? social);

  Future<SocialLoginType?> getSocialLoginType();

  Future<void> deleteSocialLoginType();
}
