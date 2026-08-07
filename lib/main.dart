import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/bootstrap/app_bootstrap.dart';
import 'core/invite/deep_link_service.dart';
import 'l10n/app_localizations.dart';
import 'core/router/pending_invite.dart';
import 'core/design_system/theme/app_theme.dart';
import 'core/local/provider/local_provider.dart';
import 'core/network/dio_provider.dart';
import 'core/notification/notification_service.dart';
import 'core/notification/provider/fcm_token_sync.dart';
import 'core/router/app_router.dart';
import 'core/router/gallery_navigation.dart';
import 'core/router/route_path.dart';
import 'data/provider/repository_provider.dart';
import 'feature/onboarding/provider/viewmodel_provider.dart';
import 'feature/splash/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 스플래시부터 상태바 색이 맞도록 초기화보다 먼저 적용한다.
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemOverlayStyle);

  runApp(const DdaraApp());
}

/// 앱의 루트 위젯.
///
/// 초기화(SDK·인증 상태·콜드 스타트 딥링크)를 마칠 때까지 [SplashPage] 를 띄우고,
/// 끝나면 라우터를 갖춘 [MyApp] 으로 교체한다. 네이티브 스플래시는 같은 색의
/// 단색 화면이라, 첫 프레임이 스플래시 화면으로 바뀌어도 배경이 이어져 보인다.
class DdaraApp extends StatefulWidget {
  const DdaraApp({super.key});

  @override
  State<DdaraApp> createState() => _DdaraAppState();
}

class _DdaraAppState extends State<DdaraApp> {
  /// 스플래시를 최소한 이만큼은 보여준다.
  ///
  /// 초기화가 빨리 끝나는 기기에서 로고가 몇 프레임만 스치고 지나가면 깜빡임처럼
  /// 보이므로, 초기화와 이 대기를 나란히 돌려 둘 다 끝난 뒤 화면을 넘긴다.
  /// (SplashPage 의 등장 애니메이션이 끝난 뒤에도 화면이 잠시 남을 만큼 잡는다)
  static const _minimumDuration = Duration(milliseconds: 1500);

  ProviderContainer? _container;

  @override
  void initState() {
    super.initState();
    // 스플래시가 먼저 그려지도록 초기화는 기다리지 않고 백그라운드로 돌린다.
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    final (container, _) = await (
      bootstrapApp(),
      Future<void>.delayed(_minimumDuration),
    ).wait;

    // 초기화 도중 루트가 사라졌다면(핫 리스타트 등) 컨테이너를 정리하고 끝낸다.
    if (!mounted) {
      container.dispose();
      return;
    }

    setState(() => _container = container);
  }

  @override
  Widget build(BuildContext context) {
    final container = _container;

    if (container == null) {
      return CupertinoApp(
        title: 'ddara',
        theme: AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SplashPage(),
      );
    }

    return UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    );
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
      unawaited(_initMessaging());
    });
  }

  /// 로컬 알림 초기화 + FCM 핸들러/토큰 동기화 코디네이터를 기동한다.
  ///
  /// 권한 요청은 기존 권한 게이트가, 토큰의 서버 등록은 코디네이터가 로그인
  /// 상태에 맞춰 처리한다. 초기화 실패는 앱 흐름을 막지 않는다.
  Future<void> _initMessaging() async {
    try {
      await NotificationService.instance.init(onTap: _handleNotificationTap);
      await NotificationService.instance.checkInitialMessage();
      // provider 를 read 해 토큰 동기화 리스너/구독을 살려 둔다.
      ref.read(fcmTokenSyncProvider);
    } catch (error) {
      debugPrint('[FCM] 초기화 실패: $error');
    }
  }

  /// 알림 탭 시 payload(data)의 id 로 해당 화면으로 이동한다.
  ///
  /// - cycleId 가 있으면(NEW_CYCLE·CYCLE_COMPLETED·DEADLINE·FRIEND_SHOT·COMMENT)
  ///   사이클 갤러리로.
  /// - 없고 groupId 만 있으면(MEMBER_JOIN·STARTER_ASSIGNED) 모임 상세로.
  ///
  /// 알림 목록의 탭 처리(notification_page)와 같은 규칙이라, 알림 종류가 늘어도
  /// 두 진입점이 함께 대응한다. (FCM data 는 값이 모두 문자열이라 파싱해서 쓴다)
  void _handleNotificationTap(Map<String, dynamic> data) {
    final router = ref.read(routerProvider);
    final groupName = data['groupName'] as String?;

    // 모임을 모르면 어느 화면으로도 갈 수 없다. (알림 종류를 불문하고 함께 온다)
    final groupId = int.tryParse('${data['groupId']}');
    if (groupId == null) {
      debugPrint('[FCM] 알림 탭 - 라우팅 대상 없음: ${data['type']}');
      return;
    }

    // 이동은 모두 홈 기준으로 스택을 다시 세운다 — 갤러리에서 뒤로 나오면
    // 그 모임으로, 모임에서 한 번 더 나오면 홈이다.
    final cycleId = int.tryParse('${data['cycleId']}');
    if (cycleId != null) {
      goCycleGallery(
        router,
        groupId: groupId,
        cycleId: cycleId,
        groupName: groupName,
      );
      return;
    }

    goGroup(router, groupId: groupId, groupName: groupName);
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
      title: 'ddara',
      theme: AppTheme.dark,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
