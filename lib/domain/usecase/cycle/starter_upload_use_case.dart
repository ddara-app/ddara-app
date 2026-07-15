import 'package:ddara/domain/repository/cycle_repository.dart';

import '../../../core/model/cycle/starter_upload.dart';

class StarterUploadUseCase {
  StarterUploadUseCase(this._cycleRepository);

  final CycleRepository _cycleRepository;

  Future<StarterUpload> call(
    int groupId,
    String topic,
    String path,
  ) async {
    return await _cycleRepository.uploadStarter(groupId, topic, path);
  }
}
