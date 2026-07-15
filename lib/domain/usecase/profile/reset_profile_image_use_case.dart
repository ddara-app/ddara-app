import 'package:ddara/domain/repository/profile_repository.dart';

class ResetProfileImageUseCase {
  ResetProfileImageUseCase(this._profileRepository);
  final ProfileRepository _profileRepository;

  /// 프로필 이미지를 기본 이미지로 되돌린다.
  Future<void> call() async {
    await _profileRepository.resetProfileImage();
  }
}
