import 'package:ddara/core/model/auth/social_login_type.dart';

sealed class LoginState {}

final class Idle extends LoginState {}

/// 소셜 인증(SDK UI) 시작부터 백엔드 로그인 완료까지의 진행 상태.
/// 진입 즉시 이 상태로 올려 다른 소셜 버튼의 재진입을 막는다.
final class LoginLoading extends LoginState {
  final SocialLoginType social;

  LoginLoading(this.social);
}

final class LoginSuccess extends LoginState {
  final SocialLoginType social;

  LoginSuccess(this.social);
}

final class SignupRequired extends LoginState {
  final SocialLoginType social;

  SignupRequired(this.social);
}

/// 로그인 실패 사유. 사용자 노출 문구는 페이지에서 l10n 으로 매핑한다.
enum LoginErrorType { unauthorized, network, unknown }

final class LoginFail extends LoginState {
  final SocialLoginType social;
  final LoginErrorType type;

  /// 분석·로깅용 상세 사유. 사용자에게 노출하지 않는다.
  final String? debugMessage;

  LoginFail(this.social, this.type, [this.debugMessage]);
}
