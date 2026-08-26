import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/onboarding/onboarding_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute onboardingRoute = GoRoute(
  path: RoutePath.onboarding,
  builder: (_, _) => const OnboardingPage(),
);
