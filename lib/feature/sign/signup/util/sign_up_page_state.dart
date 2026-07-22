import 'package:ddara/core/model/auth/social_login_type.dart';

/// 회원가입 실패 사유. 사용자 노출 문구는 페이지에서 l10n 으로 매핑한다.
enum SignUpErrorType { invalidInput, invalidToken, unsupportedProvider }

class SignUpPageState {
  final SocialLoginType social;
  final bool termsAgreed;
  final bool isLoading;
  final bool isSuccess;
  final SignUpErrorType? error;

  const SignUpPageState({
    required this.social,
    this.termsAgreed = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  SignUpPageState copyWith({
    SocialLoginType? social,
    bool? termsAgreed,
    bool? isLoading,
    bool? isSuccess,
    SignUpErrorType? error,
    bool clearError = false,
  }) {
    return SignUpPageState(
      social: social ?? this.social,
      termsAgreed: termsAgreed ?? this.termsAgreed,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      // copyWith(error: null) 은 기존 값을 유지하므로, 리셋은 clearError 로만.
      error: clearError ? null : (error ?? this.error),
    );
  }
}
