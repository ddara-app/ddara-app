import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/sign/login/login_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute loginRoute = GoRoute(
  path: RoutePath.login,
  builder: (_, _) => const LoginPage(),
);
