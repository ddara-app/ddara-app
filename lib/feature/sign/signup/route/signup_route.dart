import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/sign/signup/sign_up_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute signupRoute = GoRoute(
  path: RoutePath.signup,
  builder: (_, _) => const SignUpPage(),
);
