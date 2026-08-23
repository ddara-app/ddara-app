import 'package:ddara/core/analytics/firebase_analytics_manager.dart';
import 'package:ddara/core/router/pending_invite.dart';
import 'package:ddara/core/permission/provider/permission_provider.dart';
import 'package:ddara/core/router/route_path.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/provider/repository_provider.dart';
import '../../feature/group_create/route/group_create_route.dart';
import '../../feature/group/follower/route/follower_camera_route.dart';
import '../../feature/group/history/route/history_list_route.dart';
import '../../feature/group/random_starter/route/random_starter_route.dart';
import '../../feature/group/starter/route/starter_route.dart';
import '../../feature/group_join/invite/route/invite_code_input_route.dart';
import '../../feature/group_join/landing/route/invite_landing_route.dart';
import '../../feature/group_join/route/join_group_route.dart';
import '../../feature/home/route/home_route.dart';
import '../../feature/notification/route/notification_route.dart';
import '../../feature/onboarding/provider/viewmodel_provider.dart';
import '../../feature/onboarding/route/onboarding_route.dart';
import '../../feature/permission/route/permission_route.dart';
import '../../feature/permission/route/required_permission_route.dart';
import '../../feature/profile/account/route/account_manage_route.dart';
import '../../feature/profile/blocked/route/blocked_users_route.dart';
import '../../feature/profile/policy/route/policy_viewer_route.dart';
import '../../feature/guide/route/guide_route.dart';
import '../../feature/guide/route/guide_tour_route.dart';
import '../../feature/profile/policy/route/terms_policy_route.dart';
import '../../feature/profile/route/profile_route.dart';
import '../../feature/profile/settings/route/notification_settings_route.dart';
import '../../feature/sign/login/route/login_route.dart';
import '../../feature/sign/signup/route/signup_route.dart';

final initialRouteProvider = Provider<String>((ref) => RoutePath.login);

class AuthStateNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // 토큰 존재 여부
    final token = await ref.read(authRepositoryProvider).getAccessToken();
    return token != null && token.isNotEmpty;
  }

  void markLoggedOut() {
    state = const AsyncData(false);
  }

  void markLoggedIn() {
    state = const AsyncData(true);
  }
}

final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, bool>(
  AuthStateNotifier.new,
);

/// 콜드 스타트 시 진입할 초기 위치를 결정한다. (스플래시 단계에서 확정된 값 기준)
String resolveInitialLocation({
  required bool hasSeenOnboarding,
  required bool isLoggedIn,
  required String? pendingInvite,
  String loginPath = RoutePath.login,
}) {
  if (!hasSeenOnboarding) return RoutePath.onboarding;
  if (!isLoggedIn) return loginPath;

  final hasPendingInvite = pendingInvite != null && pendingInvite.isNotEmpty;
  return hasPendingInvite
      ? '${RoutePath.inviteLanding}?code=$pendingInvite'
      : RoutePath.home;
}

/// authStateProvider 변화를 GoRouter 의 refreshListenable 로 잇는 브리지.
/// 인증 상태가 바뀌면 라우터를 재생성하지 않고 redirect 만 다시 평가하게 한다.
class _AuthRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final routerProvider = Provider<GoRouter>((ref) {
  final loginPath = ref.read(initialRouteProvider);

  // 인증 상태가 바뀌면(로그아웃 등) 라우터를 재생성하지 않고 redirect 만 다시
  // 평가하도록 알린다. (이전엔 ref.watch 로 라우터 자체를 재생성해 스택이 초기화됐다)
  final refresh = _AuthRefreshNotifier();
  ref.onDispose(refresh.dispose);
  ref.listen(authStateProvider, (_, _) => refresh.refresh());

  // 초기 위치는 라우터 생성 시점(스플래시 단계에서 인증 상태가 이미 확정됨)에
  // 한 번만 계산한다. 이후 인증 변화는 refreshListenable + redirect 로 처리한다.
  final isLoggedIn = ref.read(authStateProvider).valueOrNull ?? false;
  final hasSeenOnboarding = ref.read(onboardingSeenProvider);

  // 콜드 스타트 초대 딥링크(main 에서 보관). 로그인 상태면 홈을 거치지 않고
  // 곧바로 landing 으로 진입한다. (미로그인이면 로그인 후 routeAfterAuth 가 소비)
  final pendingInvite = ref.read(pendingInviteCodeProvider);

  // 앱 최초 실행이면 온보딩, 그 외에는 인증·초대코드 상태에 따라 분기한다.
  final initialLocation = resolveInitialLocation(
    hasSeenOnboarding: hasSeenOnboarding,
    isLoggedIn: isLoggedIn,
    pendingInvite: pendingInvite,
    loginPath: loginPath,
  );

  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: refresh,
    // 화면 전환을 Firebase Analytics 의 screen_view 로 자동 기록한다.
    // (라우트 이름이 없는 화면은 경로가 그대로 화면 이름이 된다)
    observers: [FirebaseAnalyticsManager.observer],
    redirect: (context, state) async {
      // 라우터를 재생성하지 않으므로 매 평가 시 최신 인증 상태를 읽는다.
      final isLoggedIn = ref.read(authStateProvider).valueOrNull ?? false;

      // 로그인 상태에서 로그인 화면으로 가려 하면 홈으로 보낸다.
      if (isLoggedIn && state.matchedLocation == RoutePath.login) {
        return RoutePath.home;
      }

      // 홈 진입 직전, 카메라 권한이 없으면 권한 안내 화면으로 우회시킨다.
      // 로그인/회원가입 직후는 물론, 앱 실행 시 홈으로 분기되는 경우(자동 로그인)
      // 까지 이 한 곳에서 게이트가 동작한다.
      if (state.matchedLocation == RoutePath.home) {
        // 이번 실행에서 이미 안내를 본 경우엔 통과시킨다.
        if (ref.read(cameraNoticeAcknowledgedProvider)) return null;

        final granted = await ref
            .read(permissionServiceProvider)
            .isCameraGranted();
        if (!granted) return RoutePath.permission;

        // 이미 허용돼 홈으로 통과시키는 경우에도 안내를 본 것으로 확정한다.
        // 이렇게 해야 이후 홈 재진입(그룹→홈 등)에서 게이트가 권한을 다시
        // 조회하지 않아, 권한 상태가 not-granted 로 읽히는 순간 권한 페이지로
        // 튕기는 문제를 막는다. (routeAfterAuth 의 허용 처리와 동일 정책)
        // await 이후라 동기 빌드 구간이 아니므로 여기서 state 변경은 안전하다.
        ref.read(cameraNoticeAcknowledgedProvider.notifier).state = true;
      }

      return null;
    },
    routes: [
      onboardingRoute,
      loginRoute,
      homeRoute,
      signupRoute,
      permissionRoute,
      requiredPermissionRoute,
      profileRoute,
      accountManageRoute,
      blockedUsersRoute,
      notificationSettingsRoute,
      termsPolicyRoute,
      policyViewerRoute,
      notificationRoute,
      guideRoute,
      guideTourRoute,
      groupCreateRoute,
      inviteCodeInputRoute,
      inviteLandingRoute,
      joinGroupRoute,
      historyListRoute,
      starterRoute,
      randomStarterRoute,
      followerCameraRoute,
    ],
  );
});
