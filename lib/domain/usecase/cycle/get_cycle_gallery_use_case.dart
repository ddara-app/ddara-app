import 'package:ddara/domain/repository/cycle_repository.dart';

import '../../../core/model/group/cycle_gallery.dart';

class GetCycleGalleryUseCase {
  GetCycleGalleryUseCase(this._cycleRepository);

  final CycleRepository _cycleRepository;

  Future<CycleGallery> call(int cycleId) async {
    return await _cycleRepository.getCycleGallery(cycleId);
  }
}
