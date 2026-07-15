import 'package:ddara/core/model/auth/social_login_type.dart';

class SignUpPageState {
  final SocialLoginType social;
  final bool termsAgreed;
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;

  const SignUpPageState({
    required this.social,
    this.termsAgreed = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage = "",
  });

  SignUpPageState copyWith({
    SocialLoginType? social,
    bool? termsAgreed,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SignUpPageState(
      social: social ?? this.social,
      termsAgreed: termsAgreed ?? this.termsAgreed,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
