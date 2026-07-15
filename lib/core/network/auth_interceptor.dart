import 'package:ddara/core/local/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 모든 요청에 AccessToken 을 붙이고, 401(만료) 응답이 오면 세션 복구를 위임한 뒤
/// 원요청을 한 번 재시도한다. 복구가 불가능하면 강제 로그아웃을 위임한다.
///
/// 복구·로그아웃 로직은 직접 갖지 않고 콜백으로 주입받아 계층 분리를 유지한다.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._storage,
    required this._retryDio,
    required this._recoverSession,
    required this._onSessionExpired,
  });

  final FlutterSecureStorage _storage;

  /// 재시도 전용 Dio. 인터셉터가 없어 재시도 응답이 또 복구를 타지 않는다.
  final Dio _retryDio;

  /// 세션 복구 루틴(→ Repository.recoverSession). 새 토큰/`null`/예외를 그대로 위임.
  final Future<String?> Function() _recoverSession;

  /// 복구 불가 시 호출. (토큰·소셜 종류 정리 + 로그인 화면 전환)
  final Future<void> Function() _onSessionExpired;

  static const _retriedKey = 'retried';

  /// 인증 API(`/api/auth/*`: 로그인·회원가입·refresh·소셜 로그인) 판별.
  /// 이 경로는 (1) 토큰을 싣지 않고 (2) 복구 대상에서도 제외해 무한 재귀를 막는다.
  bool _isAuthPath(String path) => path.contains('/api/auth/');

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 인증 API(AuthRemoteDataSource → /api/auth/*)는 토큰을 싣지 않는다.
    // 그 외 요청(GroupDatasource 등)에만 AccessToken 을 자동 첨부한다.
    if (!_isAuthPath(options.path)) {
      final token = await _storage.read(key: StorageKey.accessToken);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra[_retriedKey] == true;
    final isAuthPath = _isAuthPath(err.requestOptions.path);

    // 401 이 아니거나, 이미 재시도했거나, 인증 API(재귀 방지)면 그대로 전파.
    if (!isUnauthorized || alreadyRetried || isAuthPath) {
      handler.next(err);
      return;
    }

    try {
      final newToken = await _recoverSession();
      if (newToken == null) {
        await _onSessionExpired();
        handler.next(err);
        return;
      }

      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newToken';
      options.extra[_retriedKey] = true;

      final response = await _retryDio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      // 재시도가 다시 실패 → 그 에러를 전파.
      handler.next(e);
    } catch (_) {
      // 복구 중 일시 오류(네트워크 등) → 강제 로그아웃 없이 원래 에러 전파.
      handler.next(err);
    }
  }
}
