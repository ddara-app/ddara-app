import 'package:ddara/domain/repository/cycle_repository.dart';

import '../../../core/model/cycle/follower_upload.dart';

class FollowerUploadUseCase {
  FollowerUploadUseCase(this._cycleRepository);

  final CycleRepository _cycleRepository;

  Future<FollowerUpload> call(int cycleId, String path) async {
    return await _cycleRepository.uploadFollower(cycleId, path);
  }
}
