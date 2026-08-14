import 'package:ddara/domain/model/cycle/starter_upload.dart';
import 'package:ddara/domain/repository/cycle_repository.dart';

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
