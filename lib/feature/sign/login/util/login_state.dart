import 'package:ddara/core/model/auth/social_login_type.dart';

sealed class LoginState {}

final class Idle extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class SignupRequired extends LoginState {
  final SocialLoginType social;

  SignupRequired(this.social);
}

final class LoginFail extends LoginState {
  final String message;

  LoginFail(this.message);
}
