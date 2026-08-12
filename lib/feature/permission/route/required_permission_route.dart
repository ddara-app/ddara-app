import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/permission/required_permission_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute requiredPermissionRoute = GoRoute(
  path: RoutePath.requiredPermission,
  builder: (_, _) => const RequiredPermissionPage(),
);
