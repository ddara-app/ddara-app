import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();

  factory GoogleAuthService() => _instance;

  GoogleAuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // iOS에서만 clientId 필요
    clientId: (!kIsWeb && Platform.isIOS)
        ? dotenv.get('GOOGLE_IOS_CLIENT_ID')
        : null,
  );

  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount? get currentUser => _currentUser;

  Future<String?> getGoogleAccessToken() async {
    final user = _googleSignIn.currentUser;

    if (user != null) {
      final auth = await user.authentication;
      return auth.accessToken;
    } else {
      return null;
    }
  }

  /// 구글 프로필 표시 이름을 반환한다. 세션이 없으면 null.
  /// (회원가입 시 닉네임 대신 소셜 프로필 이름으로 사용)
  String? getGoogleName() => _googleSignIn.currentUser?.displayName;

  Future<bool> isLogin() async {
    final user = _googleSignIn.currentUser;
    return user != null;
  }

  /// UI 없이 이전 구글 세션을 복원해 accessToken 을 반환한다.
  /// 캐시된 세션이 없거나 복원 실패면 null. (토큰 만료 시 무중단 재인증용)
  Future<String?> signInSilently() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account == null) return null;

      _currentUser = account;
      final auth = await account.authentication;
      return auth.accessToken;
    } catch (e) {
      return null;
    }
  }

  Future<bool> signInWithGoogle(Function(String) login) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // null 이면 사용자가 취소했거나 실패한 것 → 아무 처리도 하지 않는다.
      if (googleUser == null) return false;

      _currentUser = googleUser;

      final auth = await googleUser.authentication;
      login(auth.accessToken!);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
    } catch (_) {
      // 이미 세션이 없는 경우 등은 로그아웃된 것으로 간주.
    }
  }
}
