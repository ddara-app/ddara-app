import 'package:ddara/core/router/route_path.dart';
import 'package:ddara/feature/group/photo_viewer/photo_viewer_page.dart';
import 'package:ddara/feature/group/photo_viewer/util/photo_viewer_args.dart';
import 'package:go_router/go_router.dart';

/// 사진 상세 화면. 다른 화면과 같은 기본 전환을 쓴다. (Hero 전환은 그대로 동작)
final GoRoute photoViewerRoute = GoRoute(
  path: RoutePath.photoViewer,
  builder: (_, state) => PhotoViewerPage(args: state.extra! as PhotoViewerArgs),
);
