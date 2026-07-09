import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:ddara/core/auth/apple_credential_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

  /// 애플 로그인 후 백엔드로 보낼 Firebase ID Token 을 반환한다.
  /// 사용자가 취소하면 null 을 반환하고, 그 외 오류는 예외를 그대로 던진다.
  Future<String?> signInWithApple() {
    return Platform.isIOS ? _signInOnIOS() : _signInOnAndroid();
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

      // --- 임시 디버그: 애플 토큰 클레임 분석 (원인 확진용) ---
      final identityToken = appleCredential.identityToken;
      final claims = _decodeJwtClaims(identityToken);
      // 애플이 되돌려준 nonce 클레임은 우리가 보낸 hashedNonce 와 같아야 정상.
      final diag =
          'idTok=${identityToken != null} '
          'aud=${claims['aud']} '
          'iss=${claims['iss']} '
          'nonceOK=${claims['nonce'] == hashedNonce}';
      debugPrint('[apple] claims → $diag');
      // --- 임시 디버그 끝 ---

      final UserCredential userCredential;
      try {
        userCredential = await _auth.signInWithCredential(oauthCredential);
      } on FirebaseAuthException catch (e) {
        // 진단 정보 + Firebase 에러 코드/메시지를 로그와 UI(Toast) 양쪽에 남긴다.
        debugPrint('[apple] FirebaseAuthException code=${e.code} msg=${e.message}');
        throw AppleAuthDiagnosticException('$diag fb=${e.code} msg=${e.message}');
      }

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

  /// 임시 디버그용: 서버로 넘길 Firebase ID Token 의 `name` 클레임을 반환한다.
  /// displayName 저장·토큰 갱신 후 이름이 실제로 토큰에 실렸는지 확인하는 용도.
  /// (확인 후 제거 예정)
  String? debugNameClaimOf(String idToken) {
    return _decodeJwtClaims(idToken)['name']?.toString();
  }

  /// 임시 디버그용: JWT payload 를 검증 없이 디코드해 클레임 맵을 반환한다.
  /// (형식 오류 시 빈 맵)
  Map<String, dynamic> _decodeJwtClaims(String? jwt) {
    if (jwt == null) return const {};
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return const {};
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } catch (_) {
      return const {};
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

/// 임시 디버그용 예외. 애플 로그인 진단 정보를 담아 UI(Toast)로 노출한다.
/// (원인 확인 후 제거 예정)
class AppleAuthDiagnosticException implements Exception {
  AppleAuthDiagnosticException(this.message);

  final String message;

  @override
  String toString() => message;
}
