import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/profile/policy/terms_policy_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute termsPolicyRoute = GoRoute(
  path: RoutePath.termsPolicy,
  builder: (_, _) => const TermsPolicyPage(),
);
