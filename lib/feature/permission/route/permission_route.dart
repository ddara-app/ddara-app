import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/permission/permission_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute permissionRoute = GoRoute(
  path: RoutePath.permission,
  builder: (_, _) => const PermissionPage(),
);
