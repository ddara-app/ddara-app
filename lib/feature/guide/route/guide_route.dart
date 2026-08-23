import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/guide/guide_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute guideRoute = GoRoute(
  path: RoutePath.guide,
  builder: (_, _) => const GuidePage(),
);
