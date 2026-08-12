import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group/starter/starter_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute starterRoute = GoRoute(
  path: RoutePath.starter,
  builder: (_, state) => StarterPage(groupId: state.extra! as int),
);
