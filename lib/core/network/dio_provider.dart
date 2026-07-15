import 'package:ddara/core/local/provider/local_provider.dart';
import 'package:ddara/core/local/storage_key.dart';
import 'package:ddara/core/network/auth_interceptor.dart';
import 'package:ddara/core/router/app_router.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/data/provider/repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

BaseOptions _baseOptions() => BaseOptions(
  baseUrl: dotenv.get('API_BASE_URL'),
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  headers: {'Content-Type': 'application/json'},
);

// 명시적 타입으로 provider 타입 추론 순환을 끊는다.
// (콜백이 authRepositoryProvider·authStateProvider 를 지연 참조 → 런타임 순환 없음)
final Provider<Dio> dioProvider = Provider<Dio>((ref) {
  final dio = Dio(_baseOptions());

  // 재시도 전용 Dio. 인터셉터를 달지 않아 재시도·재귀 루프를 막는다.
  final retryDio = Dio(_baseOptions());

  final storage = ref.read(secureStorageProvider);

  dio.interceptors.add(
    AuthInterceptor(
      storage: storage,
      retryDio: retryDio,
      recoverSession: () => ref.read(authRepositoryProvider).recoverSession(),
      onSessionExpired: () => handleSessionExpired(
        storage: storage,
        // 인증 상태를 비로그인으로 즉시 확정(라우터 redirect 재평가용)한다.
        markLoggedOut: () =>
            ref.read(authStateProvider.notifier).markLoggedOut(),
        // 라우터를 재생성하지 않으므로 로그인 화면으로 직접 보낸다.
        goToLogin: () => ref.read(routerProvider).go(RoutePath.login),
      ),
    ),
  );

  return dio;
});

/// 세션 복구가 불가능할 때(401 + 재발급/재인증 실패) 강제 로그아웃을 처리한다.
///
/// 로컬 토큰·소셜 정보를 지우고 → 인증 상태를 비로그인으로 **먼저** 확정한 뒤 →
/// 로그인 화면으로 이동한다. 순서가 중요하다: [markLoggedOut] 으로 isLoggedIn 을
/// 동기 확정한 뒤 [goToLogin] 을 불러야, redirect 가 stale 값(로그인=true)을 읽고
/// 로그인 화면을 홈으로 바운스시키는 경합이 생기지 않는다.
///
/// 토큰이 이미 비워져 있으면(다른 401 핸들러가 처리) 아무것도 하지 않는다. (1회 가드)
Future<void> handleSessionExpired({
  required FlutterSecureStorage storage,
  required void Function() markLoggedOut,
  required void Function() goToLogin,
}) async {
  final hasToken = await storage.read(key: StorageKey.accessToken) != null;
  if (!hasToken) return;

  await storage.delete(key: StorageKey.accessToken);
  await storage.delete(key: StorageKey.refreshToken);
  await storage.delete(key: StorageKey.socialLoginType);

  markLoggedOut();
  goToLogin();
}
