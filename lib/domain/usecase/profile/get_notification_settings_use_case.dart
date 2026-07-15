import 'package:ddara/core/model/profile/notification_settings.dart';
import 'package:ddara/domain/repository/profile_repository.dart';

class GetNotificationSettingsUseCase {
  GetNotificationSettingsUseCase(this._profileRepository);
  final ProfileRepository _profileRepository;

  Future<NotificationSettings> call() async {
    return await _profileRepository.getNotificationSettings();
  }
}
