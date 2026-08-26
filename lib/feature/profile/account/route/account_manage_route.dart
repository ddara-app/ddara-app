import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/profile/account/account_manage_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute accountManageRoute = GoRoute(
  path: RoutePath.accountManage,
  builder: (_, _) => const AccountManagePage(),
);
