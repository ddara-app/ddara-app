import 'package:ddara/domain/model/camera/camera_guide_key.dart';
import 'package:ddara/domain/repository/profile_repository.dart';

/// 이미 본 촬영 화면 가이드의 종류를 조회한다.
class GetSeenCameraGuidesUseCase {
  GetSeenCameraGuidesUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  Future<Set<CameraGuideKey>> call() async {
    return await _profileRepository.getSeenCameraGuides();
  }
}
