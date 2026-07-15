import 'package:ddara/core/local/storage_key.dart';
import 'package:ddara/core/model/auth/social_login_type.dart';
import 'package:ddara/core/network/dto/auth/logout_response.dart';
import 'package:ddara/core/network/dto/auth/refresh_access_token_response.dart';
import 'package:ddara/core/network/dto/auth/sign_up_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/dto/auth/login_response.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio, this._storage);

  final Dio _dio;
  final FlutterSecureStorage _storage;

  Future<RefreshAccessTokenResponse> refreshAccessToken(
    String refreshToken,
  ) async {
    try {
      final response = await _dio.post(
        '/api/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      return RefreshAccessTokenResponse.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  Future<LoginResponse> signUp(SignUpRequest signUp) async {
    try {
      final response = await _dio.post(
        '/api/auth/signup',
        data: signUp.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  Future<LoginResponse> login(String token, SocialLoginType social) async {
    try {
      final response = switch (social) {
        SocialLoginType.google => await _googleLogin(token),
        SocialLoginType.kakao => await _kakaoLogin(token),
        SocialLoginType.apple => await _appleLogin(token),
      };

      return LoginResponse.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  Future<LogoutResponse> logOut(String refreshToken) async {
    final response = await _dio.post('/api/auth/logout', data: {'refreshToken': refreshToken});

    final data = response.data;
    // 서버가 JSON 객체 대신 평문 메시지(String)나 빈 본문을 반환할 수 있어 분기한다.
    if (data is Map<String, dynamic>) {
      return LogoutResponse.fromJson(data);
    }
    return LogoutResponse(message: data?.toString() ?? '');
  }

  Future<Response> _googleLogin(String token) async {
    return await _dio.post('/api/auth/google', data: {'accessToken': token});
  }

  Future<Response> _kakaoLogin(String token) async {
    return await _dio.post('/api/auth/kakao', data: {'accessToken': token});
  }

  /// 애플 로그인. [token] 은 Firebase ID Token 이며, 백엔드는 Firebase Admin SDK
  /// 로 검증한다. 이름은 토큰의 `name` 클레임(최초 로그인 시 displayName 저장분)에
  /// 담겨 오므로 별도 필드로 보내지 않는다.
  Future<Response> _appleLogin(String token) async {
    return await _dio.post('/api/auth/apple', data: {'idToken': token});
  }

  Future<void> saveAccessToken(String? token) async {
    await _storage.write(key: StorageKey.accessToken, value: token);
  }

  Future<void> saveRefreshToken(String? token) async {
    await _storage.write(key: StorageKey.refreshToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: StorageKey.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: StorageKey.refreshToken);
  }

  Future<void> saveSocialLoginType(SocialLoginType? social) async {
    await _storage.write(key: StorageKey.socialLoginType, value: social?.value);
  }

  Future<SocialLoginType?> getSocialLoginType() async {
    final value = await _storage.read(key: StorageKey.socialLoginType);
    return SocialLoginType.fromValue(value);
  }

  Future<void> deleteSocialLoginType() async {
    await _storage.delete(key: StorageKey.socialLoginType);
  }
}
