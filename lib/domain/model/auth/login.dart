import 'package:freezed_annotation/freezed_annotation.dart';

part 'login.freezed.dart';

@freezed
abstract class Login with _$Login {
  const factory Login({
    required bool isNewUser,
    required String? accessToken,
    required String? refreshToken,
  }) = _Login;
}
