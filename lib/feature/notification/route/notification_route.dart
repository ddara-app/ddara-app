import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/notification/notification_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute notificationRoute = GoRoute(
  path: RoutePath.notification,
  builder: (_, _) => const NotificationPage(),
);
