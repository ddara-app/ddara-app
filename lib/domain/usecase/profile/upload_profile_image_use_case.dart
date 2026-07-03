import 'package:ddara/domain/repository/profile_repository.dart';

class UploadProfileImageUseCase {
  UploadProfileImageUseCase(this._profileRepository);
  final ProfileRepository _profileRepository;

  /// [imagePath] 이미지를 업로드하고 새 프로필 이미지 URL을 반환한다.
  Future<String> call(String imagePath) async {
    return await _profileRepository.uploadProfileImage(imagePath);
  }
}
