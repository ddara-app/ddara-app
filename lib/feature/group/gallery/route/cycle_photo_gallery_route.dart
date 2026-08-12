import 'package:ddara/feature/group/gallery/cycle_photo_gallery.dart';
import 'package:go_router/go_router.dart';

final GoRoute cyclePhotoGalleryRoute = GoRoute(
  path: 'cycle/:cycleId',
  builder: (_, state) =>
      CyclePhotoGallery(cycleId: int.parse(state.pathParameters['cycleId']!)),
);
