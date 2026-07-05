import 'dart:async';

import 'package:ddara/core/auth/apple_auth_service.dart';
import 'package:ddara/core/auth/google_auth_service.dart';
import 'package:ddara/core/auth/kakao_auth_service.dart';
import 'package:ddara/core/exception/sign_up_exception.dart';
import 'package:ddara/core/model/auth/login.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/data/datasource/auth/auth_datasource.dart';
import 'package:ddara/data/repository/mapper/auth_mapper.dart';
import 'package:ddara/domain/model/sign_up_command.dart';
import 'package:dio/dio.dart';

import '../../core/exception/login_exception.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final KakaoAuthService _kakaoAuthService;
  final GoogleAuthService _googleAuthService;
  final AppleAuthService _appleAuthService;

  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._kakaoAuthService,
    this._googleAuthService,
    this._appleAuthService,
  );

  /// 동시에 여러 곳에서 복구를 요청해도 한 번만 수행하기 위한 단일 비행 잠금.
  Completer<String?>? _recovering;

  @override
  Future<Login> login(String token, SocialLoginType social) async {
    try {
      final response = await _authRemoteDataSource.login(token, social);
      return response.toDomain();
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 401:
          throw UnauthorizedException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<Login> signUp(SignUpCommand signUp) async {
    try {
      final response = await _authRemoteDataSource.signUp(signUp.toDto());
      return response.toDomain();
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          // termsAgreed: false, birthDate 형식 오류, 또는 nickname 누락/20자 초과
          throw TypeMisMatchException();

        case 401:
          throw UnauthorizedException();

        case 403:
          // 만 14세 미만 → 프론트: 가입 차단 안내 화면. User 저장 안 됨
          throw AgeLimitException();
        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return await _authRemoteDataSource.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _authRemoteDataSource.getRefreshToken();
  }

  @override
  Future<void> saveAccessToken(String? token) async {
    await _authRemoteDataSource.saveAccessToken(token);
  }

  @override
  Future<void> saveRefreshToken(String? token) async {
    await _authRemoteDataSource.saveRefreshToken(token);
  }

  @override
  Future<String> refreshAccessToken(String refreshToken) async {
    final response = await _authRemoteDataSource.refreshAccessToken(
      refreshToken,
    );

    return response.accessToken;
  }

  @override
  Future<void> saveSocialLoginType(SocialLoginType? social) async {
    await _authRemoteDataSource.saveSocialLoginType(social);
  }

  @override
  Future<SocialLoginType?> getSocialLoginType() async {
    return await _authRemoteDataSource.getSocialLoginType();
  }

  @override
  Future<void> deleteSocialLoginType() async {
    await _authRemoteDataSource.deleteSocialLoginType();
  }

  @override
  Future<String?> recoverSession() {
    final recovering = _recovering;
    if (recovering != null) return recovering.future;

    final completer = Completer<String?>();
    _recovering = completer;

    _runRecover()
        .then(completer.complete)
        .catchError(completer.completeError)
        .whenComplete(() => _recovering = null);

    return completer.future;
  }

  Future<String?> _runRecover() async {
    // 1. RefreshToken 으로 재발급.
    final reissued = await _reissueAccessToken();
    if (reissued != null) return reissued;

    // 2. 소셜 무중단 재인증. (마지막 로그인 소셜 정보가 있어야 분기 가능)
    final social = await _authRemoteDataSource.getSocialLoginType();
    if (social == null) return null;

    final socialToken = await _silentSocialToken(social);
    if (socialToken == null) return null;

    try {
      final login = await this.login(socialToken, social);
      // 정상 세션이 아니면(신규가입 필요/토큰 없음) 복구 실패로 처리.
      if (login.isNewUser ||
          login.accessToken == null ||
          login.refreshToken == null) {
        return null;
      }

      await _authRemoteDataSource.saveAccessToken(login.accessToken);
      await _authRemoteDataSource.saveRefreshToken(login.refreshToken);
      await _authRemoteDataSource.saveSocialLoginType(social);
      return login.accessToken;
    } on UnauthorizedException {
      // 소셜 토큰도 서버에서 거부 → 재로그인 필요.
      return null;
    }
    // NetworkException 등 일시 오류는 전파(강제 로그아웃하지 않음).
  }

  /// RefreshToken 으로 AccessToken 재발급·저장 후 반환.
  /// RefreshToken 이 없거나 만료(401)면 null, 그 외 오류는 rethrow.
  Future<String?> _reissueAccessToken() async {
    final refreshToken = await _authRemoteDataSource.getRefreshToken();
    if (refreshToken == null) return null;

    try {
      final response = await _authRemoteDataSource.refreshAccessToken(
        refreshToken,
      );
      await _authRemoteDataSource.saveAccessToken(response.accessToken);
      return response.accessToken;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) return null;
      rethrow;
    }
  }

  /// 소셜 SDK 세션에서 UI 없이 accessToken 을 재획득한다. 실패면 null.
  Future<String?> _silentSocialToken(SocialLoginType social) async {
    switch (social) {
      case SocialLoginType.google:
        return await _googleAuthService.signInSilently();
      case SocialLoginType.kakao:
        final valid = await _kakaoAuthService.availabilityToken();
        if (!valid) return null;
        return await _kakaoAuthService.getKakaoAccessToken();
      case SocialLoginType.apple:
        // Firebase 세션이 살아있으면 ID Token 을 갱신해 반환한다.
        return await _appleAuthService.getAppleIdToken();
    }
  }

  @override
  Future<bool> logOut(String refreshToken) async {
    try {
      await _authRemoteDataSource.logOut(refreshToken);
      return true;
    } on DioException {
      return false;
    }
  }
}
