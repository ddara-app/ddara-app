import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_token_request.freezed.dart';
part 'fcm_token_request.g.dart';

@freezed
abstract class FcmTokenRequest with _$FcmTokenRequest {
  const factory FcmTokenRequest({
    // FCM 이 발급한 디바이스 등록 토큰.
    required String token,
    // 발급 플랫폼. (예: "ios" / "android")
    required String platform,
  }) = _FcmTokenRequest;

  factory FcmTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenRequestFromJson(json);
}
