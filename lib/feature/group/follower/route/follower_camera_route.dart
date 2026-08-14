import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group/follower/follower_camera_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute followerCameraRoute = GoRoute(
  path: RoutePath.followerCamera,
  builder: (_, state) {
    final args =
        state.extra as ({int cycleId, String guideImageUrl, bool forceTour});
    return FollowerCameraPage(
      cycleId: args.cycleId,
      guideImageUrl: args.guideImageUrl,
      forceTour: args.forceTour,
    );
  },
);
