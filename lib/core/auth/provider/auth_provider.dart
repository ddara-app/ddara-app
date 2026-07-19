import 'package:ddara/core/auth/apple/apple_auth_service.dart';
import 'package:ddara/core/auth/google/google_auth_service.dart';
import 'package:ddara/core/auth/kakao/kakao_auth_service.dart';
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
