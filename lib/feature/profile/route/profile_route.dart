import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/profile/profile_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute profileRoute = GoRoute(
  path: RoutePath.profile,
  builder: (_, _) => const ProfilePage(),
);
