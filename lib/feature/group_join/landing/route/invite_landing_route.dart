import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group_join/landing/invite_landing_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// 사용자가 누른 이동이 아니라 초대 링크로 밀려 들어오는 화면이라,
/// 슬라이드 대신 페이드로 전환한다.
final GoRoute inviteLandingRoute = GoRoute(
  path: RoutePath.inviteLanding,
  pageBuilder: (_, state) => CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (_, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    ),
    child: InviteLandingPage(
      inviteCode: state.uri.queryParameters['code'] ?? '',
    ),
  ),
);
