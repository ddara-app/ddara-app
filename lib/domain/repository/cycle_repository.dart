import 'package:ddara/domain/model/cycle/follower_upload.dart';
import 'package:ddara/domain/model/cycle/starter_upload.dart';
import 'package:ddara/domain/model/group/cycle_gallery.dart';

abstract interface class CycleRepository {
  Future<StarterUpload> uploadStarter(int groupId, String topic, String path);

  Future<CycleGallery> getCycleGallery(int cycleId);

  Future<FollowerUpload> uploadFollower(int cycleId, String path);
}
