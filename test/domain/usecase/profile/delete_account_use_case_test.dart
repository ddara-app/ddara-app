import 'package:ddara/core/auth/apple/apple_auth_service.dart';
import 'package:ddara/core/auth/google/google_auth_service.dart';
import 'package:ddara/core/auth/kakao/kakao_auth_service.dart';
import 'package:ddara/core/exception/profile_exception.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/domain/repository/auth_repository.dart';
import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:ddara/domain/usecase/profile/delete_account_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockKakaoAuthService extends Mock implements KakaoAuthService {}

class MockGoogleAuthService extends Mock implements GoogleAuthService {}

class MockAppleAuthService extends Mock implements AppleAuthService {}

void main() {
  late MockProfileRepository profileRepository;
  late MockAuthRepository authRepository;
  late MockKakaoAuthService kakao;
  late MockGoogleAuthService google;
  late MockAppleAuthService apple;
  late DeleteAccountUseCase useCase;

  setUp(() {
    profileRepository = MockProfileRepository();
    authRepository = MockAuthRepository();
    kakao = MockKakaoAuthService();
    google = MockGoogleAuthService();
    apple = MockAppleAuthService();
    useCase = DeleteAccountUseCase(
      profileRepository,
      authRepository,
      kakao,
      google,
      apple,
    );

    when(
      () => profileRepository.deleteAccount(
        appleAuthorizationCode: any(named: 'appleAuthorizationCode'),
      ),
    ).thenAnswer((_) async {});
    when(() => authRepository.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => authRepository.saveRefreshToken(any())).thenAnswer((_) async {});
    when(() => authRepository.deleteSocialLoginType()).thenAnswer((_) async {});
    when(() => kakao.logout()).thenAnswer((_) async {});
    when(() => google.signOut()).thenAnswer((_) async {});
    when(() => apple.signOut()).thenAnswer((_) async {});
  });

  test('카카오 계정이면 서버 탈퇴 후 카카오 SDK 로그아웃·로컬 정리까지 수행하고 true 를 반환한다', () async {
    when(() => authRepository.getSocialLoginType()).thenAnswer((_) async => SocialLoginType.kakao);

    final result = await useCase.call();

    expect(result, true);
    verify(
      () => profileRepository.deleteAccount(appleAuthorizationCode: null),
    ).called(1);
    verify(() => kakao.logout()).called(1);
    verify(() => authRepository.saveAccessToken(null)).called(1);
    verify(() => authRepository.saveRefreshToken(null)).called(1);
    verify(() => authRepository.deleteSocialLoginType()).called(1);
  });

  test('이미 탈퇴한 계정(404)이어도 멱등하게 로컬 정리를 계속 진행하고 true 를 반환한다', () async {
    when(() => authRepository.getSocialLoginType()).thenAnswer((_) async => SocialLoginType.google);
    when(
      () => profileRepository.deleteAccount(
        appleAuthorizationCode: any(named: 'appleAuthorizationCode'),
      ),
    ).thenThrow(UserNotFoundException());

    final result = await useCase.call();

    expect(result, true);
    verify(() => google.signOut()).called(1);
    verify(() => authRepository.saveAccessToken(null)).called(1);
  });

  test('서버 탈퇴가 다른 이유로 실패하면 예외를 전파하고 로컬 정리는 하지 않는다', () async {
    when(() => authRepository.getSocialLoginType()).thenAnswer((_) async => SocialLoginType.kakao);
    when(
      () => profileRepository.deleteAccount(
        appleAuthorizationCode: any(named: 'appleAuthorizationCode'),
      ),
    ).thenThrow(Exception('network'));

    await expectLater(() => useCase.call(), throwsA(isA<Exception>()));

    verifyNever(() => authRepository.saveAccessToken(any()));
    verifyNever(() => kakao.logout());
  });

  test('저장된 소셜 종류가 없으면 SDK 로그아웃 없이 로컬 정리만 진행한다', () async {
    when(() => authRepository.getSocialLoginType()).thenAnswer((_) async => null);

    final result = await useCase.call();

    expect(result, true);
    verifyNever(() => kakao.logout());
    verifyNever(() => google.signOut());
    verifyNever(() => apple.signOut());
  });
}
