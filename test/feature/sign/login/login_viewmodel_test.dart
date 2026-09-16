import 'package:ddara/core/auth/apple/apple_auth_service.dart';
import 'package:ddara/core/auth/google/google_auth_service.dart';
import 'package:ddara/core/auth/kakao/kakao_auth_service.dart';
import 'package:ddara/core/auth/provider/auth_provider.dart';
import 'package:ddara/core/auth/social_auth_result.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/domain/model/auth/login.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/auth/login_use_case.dart';
import 'package:ddara/feature/sign/login/provider/viewmodel_provider.dart';
import 'package:ddara/feature/sign/login/util/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockKakaoAuthService extends Mock implements KakaoAuthService {}

class MockGoogleAuthService extends Mock implements GoogleAuthService {}

class MockAppleAuthService extends Mock implements AppleAuthService {}

void main() {
  late MockLoginUseCase loginUseCase;
  late MockKakaoAuthService kakao;
  late MockGoogleAuthService google;
  late MockAppleAuthService apple;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(SocialLoginType.kakao);
  });

  setUp(() {
    loginUseCase = MockLoginUseCase();
    kakao = MockKakaoAuthService();
    google = MockGoogleAuthService();
    apple = MockAppleAuthService();
    container = ProviderContainer(
      overrides: [
        loginUseCaseProvider.overrideWithValue(loginUseCase),
        kakaoAuthProvider.overrideWithValue(kakao),
        googleAuthProvider.overrideWithValue(google),
        appleAuthProvider.overrideWithValue(apple),
      ],
    );
    addTearDown(container.dispose);
    // autoDispose 는 구독자가 없으면 폐기되어 socialLogin() 의 await 이후
    // 상태 대입이 무시될 수 있다. 테스트 동안 살아있게 빈 리스너를 붙여 둔다.
    container.listen(loginViewModelProvider, (_, _) {});
  });

  test('초기 상태는 LoginIdle 이다', () {
    expect(container.read(loginViewModelProvider), isA<LoginIdle>());
  });

  test('카카오 로그인 성공(기존 유저)이면 LoginSuccess 로 전환한다', () async {
    when(() => kakao.signInWithKakao()).thenAnswer(
      (_) async => const SocialAuthSuccess('kakaoToken'),
    );
    when(() => loginUseCase('kakaoToken', SocialLoginType.kakao)).thenAnswer(
      (_) async => const Login(isNewUser: false, accessToken: 'a', refreshToken: 'r'),
    );

    final notifier = container.read(loginViewModelProvider.notifier);
    await notifier.socialLogin(SocialLoginType.kakao);

    final state = container.read(loginViewModelProvider);
    expect(state, isA<LoginSuccess>());
  });

  test('신규 유저면 SignupRequired 로 전환한다', () async {
    when(() => kakao.signInWithKakao()).thenAnswer(
      (_) async => const SocialAuthSuccess('kakaoToken'),
    );
    when(() => loginUseCase('kakaoToken', SocialLoginType.kakao)).thenAnswer(
      (_) async => const Login(isNewUser: true, accessToken: null, refreshToken: null),
    );

    final notifier = container.read(loginViewModelProvider.notifier);
    await notifier.socialLogin(SocialLoginType.kakao);

    expect(container.read(loginViewModelProvider), isA<SignupRequired>());
  });

  test('소셜 인증을 취소하면 LoginIdle 로 되돌아간다', () async {
    when(() => google.signInWithGoogle()).thenAnswer(
      (_) async => const SocialAuthCancelled(),
    );

    final notifier = container.read(loginViewModelProvider.notifier);
    await notifier.socialLogin(SocialLoginType.google);

    expect(container.read(loginViewModelProvider), isA<LoginIdle>());
    verifyNever(() => loginUseCase(any(), any()));
  });

  test('소셜 인증 실패는 LoginFail(unknown) 로 전환한다', () async {
    when(() => apple.signInWithApple()).thenAnswer(
      (_) async => const SocialAuthFailure('apple sdk error'),
    );

    final notifier = container.read(loginViewModelProvider.notifier);
    await notifier.socialLogin(SocialLoginType.apple);

    final state = container.read(loginViewModelProvider);
    expect(state, isA<LoginFail>());
    expect((state as LoginFail).type, LoginErrorType.unknown);
  });

  test('백엔드 로그인이 UnauthorizedException 이면 LoginFail(unauthorized) 로 전환한다', () async {
    when(() => kakao.signInWithKakao()).thenAnswer(
      (_) async => const SocialAuthSuccess('kakaoToken'),
    );
    when(
      () => loginUseCase('kakaoToken', SocialLoginType.kakao),
    ).thenThrow(UnauthorizedException());

    final notifier = container.read(loginViewModelProvider.notifier);
    await notifier.socialLogin(SocialLoginType.kakao);

    final state = container.read(loginViewModelProvider);
    expect(state, isA<LoginFail>());
    expect((state as LoginFail).type, LoginErrorType.unauthorized);
  });

  test('로딩 중 재진입은 무시한다', () async {
    when(() => kakao.signInWithKakao()).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return const SocialAuthSuccess('kakaoToken');
    });
    when(() => loginUseCase(any(), any())).thenAnswer(
      (_) async => const Login(isNewUser: false, accessToken: 'a', refreshToken: 'r'),
    );

    final notifier = container.read(loginViewModelProvider.notifier);
    final first = notifier.socialLogin(SocialLoginType.kakao);
    await notifier.socialLogin(SocialLoginType.google);
    await first;

    verifyNever(() => google.signInWithGoogle());
  });
}
