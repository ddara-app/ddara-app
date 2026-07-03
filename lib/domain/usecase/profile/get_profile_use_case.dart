import 'package:ddara/core/model/profile/profile.dart';
import 'package:ddara/domain/repository/profile_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._profileRepository);
  final ProfileRepository _profileRepository;

  Future<Profile> call() async {
    return await _profileRepository.getProfile();
  }
}
 
