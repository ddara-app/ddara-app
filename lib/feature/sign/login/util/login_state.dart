import 'package:ddara/core/model/auth/social_login_type.dart';

sealed class LoginState {}

final class Idle extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class SignupRequired extends LoginState {
  final SocialLoginType social;

  SignupRequired(this.social);
}

/// 로그인 실패 사유. 사용자 노출 문구는 페이지에서 l10n 으로 매핑한다.
enum LoginErrorType { unauthorized, network, unknown }

final class LoginFail extends LoginState {
  final LoginErrorType type;

  /// 분석·로깅용 상세 사유. 사용자에게 노출하지 않는다.
  final String? debugMessage;

  LoginFail(this.type, [this.debugMessage]);
}
