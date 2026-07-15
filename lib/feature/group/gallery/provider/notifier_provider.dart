import 'package:ddara/feature/group/gallery/cycle_photo_gallery_notifier.dart';
import 'package:ddara/feature/group/gallery/util/cycle_photo_gallery_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// autoDispose: 화면을 벗어나면 폐기되어 이전 모임의 이름이 남지 않는다.
final cyclePhotoGalleryNotifierProvider =
    NotifierProvider.autoDispose
        .family<CyclePhotoGalleryNotifier, CyclePhotoGalleryState, int>(
          CyclePhotoGalleryNotifier.new,
        );
