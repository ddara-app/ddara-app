import 'dart:async';

import 'package:ddara/core/notification/notification_service.dart';
import 'package:ddara/core/router/app_router.dart';
import 'package:ddara/data/provider/repository_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// FCM 토큰을 로그인 상태에 맞춰 백엔드와 동기화하는 코디네이터.
///
/// 토큰 등록은 인증(Bearer)이 필요하므로 **로그인 상태일 때만** 서버로 보낸다.
/// 두 경로에서 동기화한다:
///  1. [authStateProvider] 가 미로그인 → 로그인 으로 전환될 때 (로그인/세션 복구)
///  2. [NotificationService.onTokenRefresh] 로 토큰이 재발급될 때 (사용 중 교체)
///
/// 로그아웃 중 재발급된 토큰은 가드에 막혀 전송되지 않고, 다음 로그인 시 현재
/// 토큰이 자동으로 올라간다. 같은 토큰 중복 전송은 [_lastSyncedToken] 으로 막는다.
class FcmTokenSync {
  FcmTokenSync(this._ref);

  final Ref _ref;

  StreamSubscription<String>? _tokenRefreshSub;
  String? _lastSyncedToken;

  void start() {
    // 미로그인 → 로그인 전환 시 현재 토큰을 동기화한다.
    _ref.listen<AsyncValue<bool>>(authStateProvider, (previous, next) {
      final wasLoggedIn = previous?.valueOrNull ?? false;
      final isLoggedIn = next.valueOrNull ?? false;
      if (isLoggedIn && !wasLoggedIn) {
        unawaited(_sync());
      }
    });

    // FCM 재발급 구독. (로그인 상태면 _sync 내부에서 전송)
    _tokenRefreshSub = NotificationService.instance.onTokenRefresh.listen((
      token,
    ) {
      unawaited(_sync(token: token));
    });

    // 콜드 스타트에서 이미 로그인 상태면 최초 1회 동기화한다.
    if (_ref.read(authStateProvider).valueOrNull ?? false) {
      unawaited(_sync());
    }
  }

  Future<void> _sync({String? token}) async {
    // 미로그인 상태에서는 서버 등록을 건너뛴다. (인증 없음 → 401 방지)
    final isLoggedIn = _ref.read(authStateProvider).valueOrNull ?? false;
    if (!isLoggedIn) return;

    try {
      final fcmToken = token ?? await NotificationService.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;
      // 세션 내 동일 토큰 중복 전송 방지. (서버는 upsert 전제)
      if (fcmToken == _lastSyncedToken) return;

      await _ref.read(fcmRepositoryProvider).registerToken(fcmToken);
      _lastSyncedToken = fcmToken;
    } catch (error) {
      // 등록 실패는 앱 흐름을 막지 않는다. (다음 로그인/재발급 때 재시도)
      debugPrint('[FCM] 토큰 등록 실패: $error');
    }
  }

  void dispose() {
    _tokenRefreshSub?.cancel();
  }
}

/// [FcmTokenSync] 를 앱 생명주기 동안 유지하는 provider.
/// 한 번 read 하면 리스너/구독이 살아 있는다. (앱 루트에서 기동)
final fcmTokenSyncProvider = Provider<FcmTokenSync>((ref) {
  final sync = FcmTokenSync(ref);
  ref.onDispose(sync.dispose);
  sync.start();
  return sync;
});
