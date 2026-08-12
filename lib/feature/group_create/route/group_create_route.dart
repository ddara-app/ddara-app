import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group_create/group_create_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute groupCreateRoute = GoRoute(
  path: RoutePath.groupCreate,
  builder: (_, _) => const GroupCreatePage(),
);
