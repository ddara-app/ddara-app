import 'package:ddara/core/auth/apple/apple_auth_service.dart';
import 'package:ddara/core/auth/google/google_auth_service.dart';
import 'package:ddara/core/auth/kakao/kakao_auth_service.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/domain/repository/auth_repository.dart';
import 'package:ddara/domain/usecase/auth/logout_use_case.dart';
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
  late LogoutUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    kakao = MockKakaoAuthService();
    google = MockGoogleAuthService();
    apple = MockAppleAuthService();
    useCase = LogoutUseCase(repository, kakao, google, apple);

    when(() => repository.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => repository.saveRefreshToken(any())).thenAnswer((_) async {});
    when(() => repository.deleteSocialLoginType()).thenAnswer((_) async {});
    when(() => kakao.logout()).thenAnswer((_) async {});
    when(() => google.signOut()).thenAnswer((_) async {});
    when(() => apple.signOut()).thenAnswer((_) async {});
  });

  test('저장된 소셜 종류가 카카오면 카카오 SDK 로그아웃만 호출한다', () async {
    when(() => repository.getSocialLoginType()).thenAnswer((_) async => SocialLoginType.kakao);
    when(() => repository.getRefreshToken()).thenAnswer((_) async => 'refresh');
    when(() => repository.logOut('refresh')).thenAnswer((_) async => true);

    final result = await useCase.call();

    expect(result, true);
    verify(() => kakao.logout()).called(1);
    verifyNever(() => google.signOut());
    verifyNever(() => apple.signOut());
  });

  test('저장된 소셜 종류가 없으면 SDK 로그아웃을 생략한다', () async {
    when(() => repository.getSocialLoginType()).thenAnswer((_) async => null);
    when(() => repository.getRefreshToken()).thenAnswer((_) async => 'refresh');
    when(() => repository.logOut('refresh')).thenAnswer((_) async => true);

    await useCase.call();

    verifyNever(() => kakao.logout());
    verifyNever(() => google.signOut());
    verifyNever(() => apple.signOut());
  });

  test('refreshToken 이 없으면 서버 로그아웃 없이 true 를 반환하고 로컬은 정리한다', () async {
    when(() => repository.getSocialLoginType()).thenAnswer((_) async => null);
    when(() => repository.getRefreshToken()).thenAnswer((_) async => null);

    final result = await useCase.call();

    expect(result, true);
    verifyNever(() => repository.logOut(any()));
    verify(() => repository.saveAccessToken(null)).called(1);
    verify(() => repository.saveRefreshToken(null)).called(1);
    verify(() => repository.deleteSocialLoginType()).called(1);
  });

  test('refreshToken 이 있으면 서버 로그아웃 결과를 그대로 반환한다', () async {
    when(() => repository.getSocialLoginType()).thenAnswer((_) async => SocialLoginType.google);
    when(() => repository.getRefreshToken()).thenAnswer((_) async => 'refresh');
    when(() => repository.logOut('refresh')).thenAnswer((_) async => false);

    final result = await useCase.call();

    expect(result, false);
  });
}
