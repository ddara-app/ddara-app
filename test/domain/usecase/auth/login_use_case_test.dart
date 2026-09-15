import 'package:ddara/domain/model/auth/login.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/domain/repository/auth_repository.dart';
import 'package:ddara/domain/usecase/auth/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUpAll(() {
    registerFallbackValue(SocialLoginType.google);
  });

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);

    when(() => repository.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => repository.saveRefreshToken(any())).thenAnswer((_) async {});
    when(() => repository.saveSocialLoginType(any())).thenAnswer((_) async {});
  });

  test('기존 유저 로그인이면 토큰·소셜 종류를 저장한다', () async {
    const login = Login(
      isNewUser: false,
      accessToken: 'access',
      refreshToken: 'refresh',
    );
    when(
      () => repository.login('token', SocialLoginType.kakao),
    ).thenAnswer((_) async => login);

    final result = await useCase.call('token', SocialLoginType.kakao);

    expect(result, login);
    verify(() => repository.saveAccessToken('access')).called(1);
    verify(() => repository.saveRefreshToken('refresh')).called(1);
    verify(() => repository.saveSocialLoginType(SocialLoginType.kakao)).called(1);
  });

  test('신규 유저(약관 동의 전)면 토큰을 저장하지 않는다', () async {
    const login = Login(isNewUser: true, accessToken: null, refreshToken: null);
    when(
      () => repository.login('token', SocialLoginType.google),
    ).thenAnswer((_) async => login);

    final result = await useCase.call('token', SocialLoginType.google);

    expect(result, login);
    verifyNever(() => repository.saveAccessToken(any()));
    verifyNever(() => repository.saveRefreshToken(any()));
    verifyNever(() => repository.saveSocialLoginType(any()));
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.login('token', SocialLoginType.apple),
    ).thenThrow(Exception('network'));

    expect(
      () => useCase.call('token', SocialLoginType.apple),
      throwsA(isA<Exception>()),
    );
  });
}
