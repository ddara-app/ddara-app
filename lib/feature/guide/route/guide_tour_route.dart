import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/core/widget/camera/mode/camera_mode_toggle.dart';
import 'package:ddara/feature/guide/guide_tour_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute guideTourRoute = GoRoute(
  path: RoutePath.guideTour,
  builder: (_, state) => GuideTourPage(mode: state.extra! as GuideViewMode),
);
