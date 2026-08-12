import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group_join/join_group_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// 랜딩 애니메이션이 끝난 뒤라 슬라이드 대신 페이드 + 살짝 확대로 전환한다.
final GoRoute joinGroupRoute = GoRoute(
  path: RoutePath.joinGroup,
  pageBuilder: (_, state) {
    final args = state.extra as JoinGroupArgs?;
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
            child: child,
          ),
        );
      },
      child: JoinGroupPage(
        group: args?.group,
        inviteCode: args?.inviteCode ?? '',
      ),
    );
  },
);
