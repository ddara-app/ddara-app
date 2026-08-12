import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group_join/invite/invite_code_input_page.dart';
import 'package:go_router/go_router.dart';

final GoRoute inviteCodeInputRoute = GoRoute(
  path: RoutePath.inviteCodeInput,
  builder: (_, state) =>
      InviteCodeInputPage(inviteCode: state.uri.queryParameters['code'] ?? ''),
);
