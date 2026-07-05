import 'package:ddara/core/auth/apple_auth_service.dart';
import 'package:ddara/core/auth/google_auth_service.dart';
import 'package:ddara/core/auth/kakao_auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final googleAuthProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

final kakaoAuthProvider = Provider<KakaoAuthService>((ref) {
  return KakaoAuthService();
});

final appleAuthProvider = Provider<AppleAuthService>((ref) {
  return AppleAuthService();
});
