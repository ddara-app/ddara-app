import 'package:ddara/core/auth/apple/apple_auth_service.dart';
import 'package:ddara/core/auth/google/google_auth_service.dart';
import 'package:ddara/core/auth/kakao/kakao_auth_service.dart';
import 'package:ddara/domain/model/auth/login.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/domain/model/sign_up_command.dart';
import 'package:ddara/domain/repository/auth_repository.dart';
import 'package:ddara/domain/usecase/auth/signup_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockKakaoAuthService extends Mock implements KakaoAuthService {}

class MockGoogleAuthService extends Mock implements GoogleAuthService {}

class MockAppleAuthService extends Mock implements AppleAuthService {}

void main() {
  late MockAuthRepository repository;
  late MockKakaoAuthService kakao;
  late MockGoogleAuthService google;
  late MockAppleAuthService apple;
  late SignUpUseCase useCase;

  setUpAll(() {
    registerFallbackValue(SocialLoginType.google);
    registerFallbackValue(
      const SignUpCommand(provider: 'KAKAO', accessToken: 't', termsAgreed: true),
    );
  });

  setUp(() {
    repository = MockAuthRepository();
    kakao = MockKakaoAuthService();
    google = MockGoogleAuthService();
    apple = MockAppleAuthService();
    useCase = SignUpUseCase(repository, kakao, google, apple);

    when(() => repository.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => repository.saveRefreshToken(any())).thenAnswer((_) async {});
    when(() => repository.saveSocialLoginType(any())).thenAnswer((_) async {});
  });

  test('카카오 회원가입은 카카오 토큰으로 signUp 을 호출하고 결과 토큰을 저장한다', () async {
    when(() => kakao.getKakaoAccessToken()).thenAnswer((_) async => 'kakaoToken');
    const login = Login(isNewUser: true, accessToken: 'access', refreshToken: 'refresh');
    when(() => repository.signUp(any())).thenAnswer((_) async => login);

    await useCase.call(SocialLoginType.kakao, true);

    final captured = verify(() => repository.signUp(captureAny())).captured;
    final command = captured.single as SignUpCommand;
    expect(command.provider, 'KAKAO');
    expect(command.accessToken, 'kakaoToken');
    expect(command.termsAgreed, true);
    verify(() => repository.saveAccessToken('access')).called(1);
    verify(() => repository.saveRefreshToken('refresh')).called(1);
    verify(() => repository.saveSocialLoginType(SocialLoginType.kakao)).called(1);
  });

  test('애플 회원가입 성공 후 Keychain 백업을 삭제한다', () async {
    when(() => apple.getAppleIdToken()).thenAnswer((_) async => 'appleToken');
    when(() => apple.clearCredentialBackup()).thenAnswer((_) async {});
    const login = Login(isNewUser: true, accessToken: 'access', refreshToken: 'refresh');
    when(() => repository.signUp(any())).thenAnswer((_) async => login);

    await useCase.call(SocialLoginType.apple, true);

    verify(() => apple.clearCredentialBackup()).called(1);
  });

  test('구글 회원가입은 애플 Keychain 백업을 건드리지 않는다', () async {
    when(() => google.getGoogleAccessToken()).thenAnswer((_) async => 'googleToken');
    const login = Login(isNewUser: true, accessToken: 'access', refreshToken: 'refresh');
    when(() => repository.signUp(any())).thenAnswer((_) async => login);

    await useCase.call(SocialLoginType.google, true);

    verifyNever(() => apple.clearCredentialBackup());
  });
}
