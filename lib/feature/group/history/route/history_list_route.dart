import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group/history/history_list_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute historyListRoute = GoRoute(
  path: RoutePath.historyList,
  builder: (_, state) => HistoryListPage(groupId: state.extra! as int),
);
