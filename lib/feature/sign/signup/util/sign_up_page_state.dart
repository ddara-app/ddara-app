/// 회원가입 실패 사유. 사용자 노출 문구는 페이지에서 l10n 으로 매핑한다.
enum SignUpErrorType { invalidInput, invalidToken, unsupportedProvider, unknown }

/// 가입 제출 진행 상태. (login 의 LoginState 와 같은 sealed 설계 —
/// 로딩·성공·실패가 상호배타라 불가능한 조합이 타입 수준에서 차단된다)
sealed class SignUpSubmitState {
  const SignUpSubmitState();
}

final class SignUpIdle extends SignUpSubmitState {
  const SignUpIdle();
}

final class SignUpLoading extends SignUpSubmitState {
  const SignUpLoading();
}

final class SignUpSuccess extends SignUpSubmitState {
  const SignUpSuccess();
}

final class SignUpError extends SignUpSubmitState {
  const SignUpError(this.type);

  final SignUpErrorType type;
}

/// 가입 화면 상태. 사용자 입력(termsAgreed)과 제출 진행 상태(submit)를
/// 분리해 담는다. social 은 family 파라미터라 notifier 의 `arg` 로 접근한다.
class SignUpPageState {
  final bool termsAgreed;
  final SignUpSubmitState submit;

  const SignUpPageState({
    this.termsAgreed = false,
    this.submit = const SignUpIdle(),
  });

  SignUpPageState copyWith({bool? termsAgreed, SignUpSubmitState? submit}) {
    return SignUpPageState(
      termsAgreed: termsAgreed ?? this.termsAgreed,
      submit: submit ?? this.submit,
    );
  }
}
