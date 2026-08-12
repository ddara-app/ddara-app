import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group/detail/route/group_route.dart';
import 'package:ddara/feature/home/home_page.dart';
import 'package:go_router/go_router.dart';

/// 모임·갤러리를 홈 하위에 중첩해, 딥링크로 갤러리에 바로 들어가도 go 한 번이면
/// 홈 > 모임 > 갤러리 스택이 함께 구성되게 한다.
final GoRoute homeRoute = GoRoute(
  path: RoutePath.home,
  builder: (_, _) => const HomePage(),
  routes: [groupRoute],
);
