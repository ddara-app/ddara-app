import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/profile/settings/notification_settings_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute notificationSettingsRoute = GoRoute(
  path: RoutePath.notificationSettings,
  builder: (_, _) => const NotificationSettingsPage(),
);
