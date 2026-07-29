import 'package:app_links/app_links.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../analytics/mixpanel_manager.dart';
import '../invite/deep_link_service.dart';
import '../local/fresh_install_guard.dart';
import '../local/provider/local_provider.dart';
import '../notification/notification_service.dart';
import '../router/app_router.dart';
import '../router/pending_invite.dart';
import '../../firebase_options.dart';

/// 앱 실행에 필요한 초기화를 모두 마치고 [ProviderContainer] 를 돌려준다.
///
/// 스플래시 화면(SplashPage)이 그려진 뒤 백그라운드에서 수행되며, 완료되면
/// 루트 위젯이 실제 앱 화면으로 교체한다. 어느 단계가 실패해도 화면이 스플래시에
/// 갇히지 않도록, 실패는 모두 삼키고 가능한 상태로 계속 진행한다.
Future<ProviderContainer> bootstrapApp() async {
  await _initExternalSdks();

  final container = await _createContainer();

  try {
    // 재설치 후 첫 실행이면 iOS Keychain 에 잔존한 이전 설치의 토큰을 정리한다.
    // 인증 상태(_confirmAuthState)가 잔존 토큰을 읽어 로그인 상태로 오인하기
    // 전에 반드시 먼저 수행해야 한다.
    await clearSecureStorageOnFreshInstall(
      prefs: container.read(sharedPreferencesProvider),
      storage: container.read(secureStorageProvider),
    );
  } catch (error) {
    debugPrint('[bootstrap] 재설치 토큰 정리 실패: $error');
  }

  await _confirmAuthState(container);
  await _captureColdStartInvite(container);

  return container;
}

/// dotenv·Kakao·Mixpanel·Firebase 등 외부 SDK 를 초기화한다.
///
/// 한 단계가 실패하면 뒤따르는 단계도 함께 건너뛰지만(대개 dotenv 값에 의존),
/// 앱 실행 자체는 막지 않는다.
Future<void> _initExternalSdks() async {
  try {
    await dotenv.load(fileName: '.env');
    KakaoSdk.init(nativeAppKey: dotenv.get("KAKAO_NATIVE_APP_KEY"));
    await MixpanelManager.init();
    await _initFirebase();
    _registerFcmBackgroundHandler();
  } catch (error) {
    debugPrint('[bootstrap] 외부 SDK 초기화 실패: $error');
  }
}

/// Firebase 초기화 + Crashlytics 에러 보고 연결 + Performance·Analytics 수집 설정.
///
/// Doze 복귀 직후 Play Services 불안정 등으로 초기화가 멈추거나 실패해도 앱은
/// 계속 실행한다. (Crashlytics 없이 동작 — 스플래시만 붙잡지 않는다)
Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 10));

    // Flutter 프레임워크에서 발생한 에러를 Crashlytics 로 보고
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // 프레임워크가 잡지 못한 비동기/플랫폼 에러를 Crashlytics 로 보고
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // 디버그 빌드의 성능 데이터가 콘솔 지표를 오염시키지 않도록
    // Performance 수집은 릴리스 빌드에서만 켠다.
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(
      kReleaseMode,
    );

    // 같은 이유로 Analytics 수집도 릴리스 빌드에서만 켠다.
    // (개발 중 이벤트 확인은 DebugView 를 켜고 확인한다 —
    //  docs/tech_stack.md 의 Firebase Analytics 항목 참고)
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
      kReleaseMode,
    );
  } catch (_) {
    // Firebase 초기화 실패·지연은 무시하고 진행한다.
  }
}

/// FCM 백그라운드/종료 상태 메시지 핸들러를 등록한다.
///
/// Firebase 초기화 이후 앱 화면 진입 전 1회 호출한다. Firebase 미초기화 등으로
/// 실패해도 앱 실행은 계속한다. (알림 없이 동작)
void _registerFcmBackgroundHandler() {
  try {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (_) {
    // 등록 실패는 무시하고 진행한다.
  }
}

/// 라우터가 초기 분기에 사용할 ProviderContainer 를 만든다.
///
/// 온보딩 플래그 등을 동기적으로 읽을 수 있도록 SharedPreferences 를 미리 로드해
/// override 로 주입한다.
Future<ProviderContainer> _createContainer() async {
  final prefs = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

/// 라우터가 초기 위치를 잡을 수 있도록 인증 상태(로그인 여부)를 미리 확정한다.
Future<void> _confirmAuthState(ProviderContainer container) async {
  try {
    await container.read(authStateProvider.future);
  } catch (_) {
    // 인증 확인 실패 시 비로그인으로 처리
  }
}

/// 콜드 스타트 초대 딥링크를 라우터 생성 전에 읽어 보관한다.
///
/// (라우터가 이 코드를 보고 초기 위치를 landing 으로 잡아, 홈이 먼저 그려졌다
///  landing 으로 튕기는 깜빡임을 없앤다)
Future<void> _captureColdStartInvite(ProviderContainer container) async {
  try {
    final initialUri = await AppLinks().getInitialLink().timeout(
      const Duration(seconds: 3),
    );
    final code = DeepLinkService.parseInviteCode(initialUri);
    if (code != null) {
      container.read(pendingInviteCodeProvider.notifier).state = code;
    }
  } catch (_) {
    // 초기 링크 조회 실패·지연은 무시한다. (스트림으로도 들어올 수 있음)
  }
}
