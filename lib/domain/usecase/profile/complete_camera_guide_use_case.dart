import 'package:ddara/domain/model/camera/camera_guide_key.dart';
import 'package:ddara/domain/repository/profile_repository.dart';

/// 촬영 화면 가이드를 본 것으로 기록한다.
///
/// 시청 기록이 없어 자동으로 뜬 안내를 끝까지 봤을 때만 호출한다.
/// (가이드 화면에서 다시 보는 시연은 기록하지 않는다)
class CompleteCameraGuideUseCase {
  CompleteCameraGuideUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  Future<void> call(CameraGuideKey key) async {
    await _profileRepository.completeCameraGuide(key);
  }
}
