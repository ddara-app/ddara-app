import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_access_token_response.freezed.dart';
part 'refresh_access_token_response.g.dart';

@freezed
abstract class RefreshAccessTokenResponse with _$RefreshAccessTokenResponse {
  const factory RefreshAccessTokenResponse({required String accessToken}) =
      _RefreshAccessTokenResponse;

  factory RefreshAccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshAccessTokenResponseFromJson(json);
}
