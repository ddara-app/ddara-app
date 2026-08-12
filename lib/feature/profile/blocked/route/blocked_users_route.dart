import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/profile/blocked/blocked_users_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute blockedUsersRoute = GoRoute(
  path: RoutePath.blockedUsers,
  builder: (_, _) => const BlockedUsersPage(),
);
