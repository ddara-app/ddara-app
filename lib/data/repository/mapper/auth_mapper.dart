import 'package:ddara/core/model/auth/login.dart';
import 'package:ddara/core/network/dto/auth/login_response.dart';
import 'package:ddara/core/network/dto/auth/sign_up_request.dart';
import 'package:ddara/domain/model/sign_up_command.dart';

extension LoginMapper on LoginResponse {
  Login toDomain() {
    return Login(
      isNewUser: isNewUser,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

extension SignUpMapper on SignUpCommand {
  SignUpRequest toDto() {
    return SignUpRequest(
      provider: provider,
      accessToken: accessToken,
      termsAgreed: termsAgreed,
    );
  }
}
