import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/policy/policy_viewer_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute policyViewerRoute = GoRoute(
  path: RoutePath.policyViewer,
  builder: (_, state) =>
      PolicyViewerPage(args: state.extra! as PolicyViewerArgs),
);
