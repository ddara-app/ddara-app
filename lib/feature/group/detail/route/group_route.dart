import 'package:ddara/feature/group/detail/group_page.dart';
import 'package:ddara/feature/group/gallery/route/cycle_photo_gallery_route.dart';
import 'package:go_router/go_router.dart';

final GoRoute groupRoute = GoRoute(
  path: 'group/:groupId',
  builder: (_, state) {
    final groupId = int.parse(state.pathParameters['groupId']!);
    // 갤러리까지 한 번에 이동하는 경우 extra 는 두 라우트가 공유하므로,
    // 힌트가 아니면 무시한다.
    final extra = state.extra;
    final args = extra is GroupPageArgs ? extra : null;

    return GroupPage(
      groupId: groupId,
      groupName: args?.groupName,
      hasCurrentCycle: args?.hasCurrentCycle,
      thumbnailUrl: args?.thumbnailUrl,
    );
  },
  routes: [cyclePhotoGalleryRoute],
);
