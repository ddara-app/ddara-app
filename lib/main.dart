import 'dart:async';
import 'dart:ui';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/deeplink/deep_link_service.dart';
import 'l10n/app_localizations.dart';
import 'core/deeplink/pending_invite.dart';
import 'core/designsystem/theme/app_theme.dart';
import 'core/local/provider/local_provider.dart';
import 'core/network/dio_provider.dart';
import 'core/router/app_router.dart';
import 'core/router/route_path.dart';
import 'data/provider/repository_provider.dart';
import 'feature/onboarding/provider/onboarding_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // 초기화가 끝날 때까지 네이티브 스플래시를 화면에 유지한다.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  late final ProviderContainer container;
  try {
    await dotenv.load(fileName: '.env');
    KakaoSdk.init(nativeAppKey: dotenv.get("KAKAO_NATIVE_APP_KEY"));
    await _initCrashReporting();
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemOverlayStyle);

    container = await _createContainer();
    await _confirmAuthState(container);
    await _captureColdStartInvite(container);
  } finally {
    // 초기화 중 어느 단계가 예외를 던지거나 지연돼도 네이티브 스플래시가 화면에
    // 갇히지 않도록 제거를 보장한다. (콜드 스타트 시 Firebase·딥링크 지연/실패 대비)
    FlutterNativeSplash.remove();
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

/// Firebase 초기화 + Crashlytics 에러 보고 연결.
///
/// Doze 복귀 직후 Play Services 불안정 등으로 초기화가 멈추거나 실패해도 앱은
/// 계속 실행한다. (Crashlytics 없이 동작 — 스플래시만 붙잡지 않는다)
Future<void> _initCrashReporting() async {
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
  } catch (_) {
    // Firebase 초기화 실패·지연은 무시하고 진행한다.
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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final DeepLinkService _deepLink;

  @override
  void initState() {
    super.initState();
    // 딥링크 단일 진입점. (oauth 콜백 무시 + 초대 딥링크 → _onInvite 게이트 흐름)
    _deepLink = DeepLinkService(onInvite: _onInvite);
    // 라우터가 초기 위치를 잡은 뒤 첫 프레임 이후에 딥링크 처리와
    // 백그라운드 세션 복구를 시작한다. (스플래시는 이미 제거된 뒤)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deepLink.init();
      unawaited(_recoverSession());
    });
  }

  /// 콜드 스타트 시 스플래시를 네트워크에 묶지 않기 위해, 로컬 토큰으로 낙관적
  /// 진입한 뒤 실제 세션 복구(재발급 → 실패 시 소셜 무중단 재인증)를
  /// **백그라운드에서** 수행한다.
  ///
  /// - 복구 성공: 로그인 상태를 확정(유지)한다.
  /// - 복구 불가(재발급·재인증 모두 실패 → 만료 확정): 강제 로그아웃 후 로그인 화면.
  /// - 네트워크 등 일시 오류: 로그인 상태를 유지한다.
  ///   (실제로 만료였다면 이후 인증 API 401 응답에서 인터셉터가 처리한다)
  Future<void> _recoverSession() async {
    final notifier = ref.read(authStateProvider.notifier);

    // 낙관적 로그인 상태(로컬 토큰 존재)에서만 복구를 시도한다.
    if (!(ref.read(authStateProvider).valueOrNull ?? false)) return;

    try {
      final token = await ref.read(authRepositoryProvider).recoverSession();
      if (token != null) {
        notifier.markLoggedIn();
        return;
      }

      // 재발급·소셜 재인증 모두 실패 → 세션 만료로 확정. 토큰 정리 + 로그인 화면.
      // (인터셉터의 401 처리와 동일한 강제 로그아웃 루틴을 재사용한다)
      await handleSessionExpired(
        storage: ref.read(secureStorageProvider),
        markLoggedOut: notifier.markLoggedOut,
        goToLogin: () => ref.read(routerProvider).go(RoutePath.login),
      );
    } catch (_) {
      // 네트워크 등 일시 오류 → 로그인 상태 유지.
    }
  }

  /// 딥링크에서 받은 초대코드로 모임 참여 흐름을 시작한다.
  ///
  /// 딥링크는 로그아웃·권한 미허용 상태에서도 외부에서 진입할 수 있으므로,
  /// 초대코드를 보관해두고 상황에 맞는 화면으로 보낸다. (로그인/온보딩/권한)
  /// 각 단계가 끝나면 routeAfterAuth 가 보관된 코드로 참여 화면에 복귀시킨다.
  Future<void> _onInvite(String inviteCode) async {
    final router = ref.read(routerProvider);
    final token = await ref.read(authRepositoryProvider).getAccessToken();

    // 초대코드는 항상 보관한다. (권한 게이트 통과 후 routeAfterAuth 가 소비)
    ref.read(pendingInviteCodeProvider.notifier).state = inviteCode;

    // 미로그인 상태면 인증 흐름부터. (첫 진입이면 온보딩, 그 외엔 로그인)
    if (token == null || token.isEmpty) {
      final seenOnboarding = ref.read(onboardingSeenProvider);
      router.go(seenOnboarding ? RoutePath.login : RoutePath.onboarding);
      return;
    }

    // 로그인됨 → 권한 게이트를 거쳐 참여 화면으로. (권한 없으면 PermissionPage)
    await routeAfterAuth(ref, router);
  }

  @override
  void dispose() {
    _deepLink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return CupertinoApp.router(
      title: 'Ddara',
      theme: AppTheme.dark,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
