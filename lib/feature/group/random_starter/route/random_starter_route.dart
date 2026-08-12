import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group/random_starter/random_starter_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// 모임 진입 직후 자동으로 열리는 화면이라, 슬라이드로 밀고 들어오면 사용자가
/// 누르지 않은 이동처럼 느껴진다. 페이드로 전환한다.
///
/// CTA 는 공개된 스타터(GroupMember)를 결과로 pop 하므로, 이후 진행은 push 한
/// 호출부가 결정한다.
final GoRoute randomStarterRoute = GoRoute(
  path: RoutePath.randomStarter,
  pageBuilder: (_, state) => CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (_, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    ),
    child: RandomStarterPage(args: state.extra! as RandomStarterArgs),
  ),
);
