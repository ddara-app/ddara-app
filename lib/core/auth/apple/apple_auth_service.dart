import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:ddara/core/analytics/crashlytics_manager.dart';
import 'package:ddara/core/auth/apple/apple_credential_storage.dart';
import 'package:ddara/core/auth/social_auth_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Sign in with Apple → Firebase 로그인을 담당한다.
///
/// 플랫폼별로 흐름이 다르다.
/// - **iOS**: [SignInWithApple] 네이티브 흐름으로 애플 credential 을 받아 Firebase
///   자격증명으로 교환한다. credential 에서 최초 로그인 이름을 직접 받을 수 있다.
/// - **Android**: 애플 네이티브 SDK 가 없으므로 [FirebaseAuth.signInWithProvider]
///   로 Firebase 가 웹 OAuth 흐름 전체(Custom Tab → `firebaseapp.com/__/auth/handler`)
///   를 처리한다. 이름은 Firebase 가 최초 로그인 시 자동으로 displayName 에 채운다.
///
/// 두 경우 모두 최종적으로 **Firebase ID Token** 을 백엔드로 넘긴다. (백엔드는
/// Firebase Admin SDK 로 검증)
///
/// 이름 처리: 애플은 이름을 **최초 로그인 1회만** 준다. idToken 자체엔 이름이 없으므로
/// 최초 로그인 때 displayName 을 저장하고 토큰을 강제 갱신(`getIdToken(true)`)해야
/// Firebase ID Token 의 `name` 클레임에 실린다. 한 번 저장한 displayName 은 Firebase
/// 계정에 영구 보존되어 이후 로그인에도 유지된다.
class AppleAuthService {
  static final AppleAuthService _instance = AppleAuthService._internal();

  factory AppleAuthService() => _instance;

  AppleAuthService._internal();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// 최초 1회만 내려오는 애플 이름/이메일의 Keychain 백업 저장소.
  final AppleCredentialStorage _credentialStorage = AppleCredentialStorage();

  /// 애플 로그인 후 백엔드로 보낼 Firebase ID Token 을 결과로 반환한다.
  Future<SocialAuthResult> signInWithApple() async {
    try {
      final idToken = Platform.isIOS
          ? await _signInOnIOS()
          : await _signInOnAndroid();

      // null 이면 사용자가 취소한 것.
      if (idToken == null) return const SocialAuthCancelled();
      return SocialAuthSuccess(idToken);
    } catch (error, stack) {
      // 취소는 플랫폼별 흐름 안에서 이미 null 로 걸러져 여기 오지 않는다.
      // 남는 것은 Firebase 자격증명 교환 실패 등 손봐야 할 문제뿐이다.
      unawaited(
        CrashlyticsManager.instance.recordError(
          error,
          stack,
          reason: 'apple sign-in failed',
        ),
      );
      return SocialAuthFailure('$error');
    }
  }

  /// iOS: 애플 네이티브 흐름 → Firebase 자격증명 교환.
  Future<String?> _signInOnIOS() async {
    try {
      // nonce 준비. (애플엔 SHA256 해시, Firebase 엔 raw 를 전달 — 재생 공격 방지)
      final rawNonce = _generateNonce();
      final hashedNonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      // 애플은 이름/이메일을 최초 authorization 1회만 준다. 이후 단계(Firebase
      // 교환·회원가입)가 실패하거나 앱이 종료돼도 잃지 않도록, credential 을
      // 받은 즉시 Keychain 에 백업한다. (null 이면 기존 백업을 보존)
      final userIdentifier = appleCredential.userIdentifier;
      if (userIdentifier != null) {
        await _credentialStorage.saveName(
          userIdentifier,
          _composeName(appleCredential.givenName, appleCredential.familyName),
        );
        await _credentialStorage.saveEmail(
          userIdentifier,
          appleCredential.email,
        );
      }

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      // 최초 로그인 때만 이름을 받는다 → displayName 에 저장.
      // 이번 credential 에 이름이 없으면(2회차 이후 로그인) Keychain 백업에서
      // 복구한다 — 최초 로그인 후 회원가입 전에 앱이 종료된 경우를 구제.
      var displayName = _composeName(
        appleCredential.givenName,
        appleCredential.familyName,
      );
      if (displayName == null && userIdentifier != null) {
        displayName = await _credentialStorage.readName(userIdentifier);
      }
      return _idTokenAfterNameUpdate(userCredential.user, displayName);
    } on SignInWithAppleAuthorizationException catch (e) {
      // 사용자가 취소한 경우는 오류가 아니라 취소로 처리.
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }

  /// Android: Firebase 가 웹 OAuth 흐름 전체를 처리한다.
  Future<String?> _signInOnAndroid() async {
    try {
      final provider = OAuthProvider('apple.com')
        ..addScope('email')
        ..addScope('name');

      final userCredential = await _auth.signInWithProvider(provider);

      // Firebase 가 최초 로그인 시 displayName 을 자동으로 채운다. 없으면 이름 클레임
      // 이 비어도 그대로 진행(2회차 이후엔 계정에 저장된 이름이 이미 실려 온다).
      return _idTokenAfterNameUpdate(
        userCredential.user,
        userCredential.user?.displayName,
      );
    } on FirebaseAuthException catch (e) {
      // 사용자가 Custom Tab 을 닫은 경우 등은 취소로 처리.
      if (e.code == 'canceled' || e.code == 'web-context-canceled') return null;
      rethrow;
    }
  }

  /// displayName 이 있으면 저장 후 토큰을 강제 갱신해 name 클레임을 포함시킨다.
  /// 없으면 현재 토큰을 그대로 반환한다.
  Future<String?> _idTokenAfterNameUpdate(User? user, String? displayName) async {
    if (user == null) return null;
    if (displayName != null &&
        displayName.isNotEmpty &&
        displayName != user.displayName) {
      await user.updateDisplayName(displayName);
      return await user.getIdToken(true);
    }
    return await user.getIdToken();
  }

  /// UI 없이 현재 Firebase 세션에서 ID Token 을 재획득한다. (토큰 만료 시 무중단 재인증용)
  /// 세션이 없으면 null. Firebase 가 만료된 토큰을 자동 갱신한다.
  Future<String?> getAppleIdToken() async {
    try {
      return await _auth.currentUser?.getIdToken();
    } catch (_) {
      return null;
    }
  }

  /// 회원가입이 끝나 서버에 이름이 저장된 뒤, 더 이상 불필요한 Keychain 백업을
  /// 삭제한다. 애플 계정 식별자는 Firebase 계정의 apple.com providerData 에서
  /// 얻는다. (credential.userIdentifier 와 동일한 값)
  Future<void> clearCredentialBackup() async {
    try {
      final providerData = _auth.currentUser?.providerData ?? const [];
      for (final info in providerData) {
        if (info.providerId == 'apple.com' && info.uid != null) {
          await _credentialStorage.delete(info.uid!);
        }
      }
    } catch (_) {
      // 백업 삭제 실패는 로그인/가입 흐름에 영향을 주지 않는다.
    }
  }

  /// 회원탈퇴용 애플 재인증. 애플 연동 해제(token revoke)에 쓸
  /// authorizationCode 를 반환한다. 사용자가 취소하면 null.
  ///
  /// iOS 전용 — 안드로이드는 네이티브 재인증 수단이 없어 null 을 반환한다.
  /// 애플 authorizationCode 는 유효시간이 짧으므로(약 5분, 1회용) 받은 즉시
  /// 서버로 보내야 한다.
  Future<String?> getAuthorizationCodeForRevoke() async {
    if (!Platform.isIOS) return null;
    try {
      // 이름·이메일이 필요 없으므로 scope 없이 인증만 받는다.
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [],
      );
      return credential.authorizationCode;
    } on SignInWithAppleAuthorizationException catch (e) {
      // 사용자가 취소한 경우는 오류가 아니라 취소로 처리.
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }

  /// Firebase 세션 정리. (로그아웃·회원탈퇴 시 호출)
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {
      // 이미 세션이 없는 경우 등은 로그아웃된 것으로 간주.
    }
  }

  /// 성/이름 조합. 애플은 둘을 분리해 주며 둘 다 없을 수 있다.
  /// 한글 이름 관례에 맞춰 성 + 이름 순으로 붙인다.
  String? _composeName(String? givenName, String? familyName) {
    final name = '${familyName ?? ''}${givenName ?? ''}'.trim();
    return name.isEmpty ? null : name;
  }

  /// 랜덤 nonce 문자열 생성.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
