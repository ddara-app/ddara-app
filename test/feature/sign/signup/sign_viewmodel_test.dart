import 'package:ddara/core/exception/sign_up_exception.dart';
import 'package:ddara/domain/model/auth/social_login_type.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/auth/signup_use_case.dart';
import 'package:ddara/feature/sign/signup/provider/viewmodel_provider.dart';
import 'package:ddara/feature/sign/signup/util/sign_up_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  late MockSignUpUseCase useCase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(SocialLoginType.kakao);
  });

  setUp(() {
    useCase = MockSignUpUseCase();
    container = ProviderContainer(
      overrides: [signUpUseCaseProvider.overrideWithValue(useCase)],
    );
    addTearDown(container.dispose);
    // autoDispose 는 구독자가 없으면 폐기되어 signUp() 의 await 이후 상태
    // 대입이 무시될 수 있다. 테스트 동안 살아있게 빈 리스너를 붙여 둔다.
    container.listen(signViewModelProvider(SocialLoginType.kakao), (_, _) {});
  });

  test('초기 상태는 약관 미동의·제출 전(Idle) 이다', () {
    final state = container.read(signViewModelProvider(SocialLoginType.kakao));

    expect(state.termsAgreed, false);
    expect(state.submit, isA<SignUpIdle>());
  });

  test('termsAgreedChanged 는 동의 여부만 갱신한다', () {
    final notifier = container.read(
      signViewModelProvider(SocialLoginType.kakao).notifier,
    );

    notifier.termsAgreedChanged(true);

    expect(
      container.read(signViewModelProvider(SocialLoginType.kakao)).termsAgreed,
      true,
    );
  });

  test('signUp 성공하면 SignUpSuccess 로 전환한다', () async {
    when(() => useCase(SocialLoginType.kakao, any())).thenAnswer((_) async {});
    final notifier = container.read(
      signViewModelProvider(SocialLoginType.kakao).notifier,
    );

    await notifier.signUp();

    expect(
      container.read(signViewModelProvider(SocialLoginType.kakao)).submit,
      isA<SignUpSuccess>(),
    );
  });

  test('TypeMisMatchException 은 invalidInput 에러로 전환한다', () async {
    when(() => useCase(SocialLoginType.kakao, any())).thenThrow(TypeMisMatchException());
    final notifier = container.read(
      signViewModelProvider(SocialLoginType.kakao).notifier,
    );

    await notifier.signUp();

    final submit = container.read(signViewModelProvider(SocialLoginType.kakao)).submit;
    expect(submit, isA<SignUpError>());
    expect((submit as SignUpError).type, SignUpErrorType.invalidInput);
  });

  test('예상 밖 예외는 unknown 에러로 전환한다', () async {
    when(() => useCase(SocialLoginType.kakao, any())).thenThrow(Exception('boom'));
    final notifier = container.read(
      signViewModelProvider(SocialLoginType.kakao).notifier,
    );

    await notifier.signUp();

    final submit = container.read(signViewModelProvider(SocialLoginType.kakao)).submit;
    expect(submit, isA<SignUpError>());
    expect((submit as SignUpError).type, SignUpErrorType.unknown);
  });
}
