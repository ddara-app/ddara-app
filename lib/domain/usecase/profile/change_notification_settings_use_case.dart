import 'package:ddara/core/model/profile/notification_settings.dart';
import 'package:ddara/domain/repository/profile_repository.dart';

class ChangeNotificationSettingsUseCase {
  ChangeNotificationSettingsUseCase(this._profileRepository);
  final ProfileRepository _profileRepository;

  Future<NotificationSettings> call(NotificationSettings settings) async {
    return await _profileRepository.changeNotificationSettings(settings);
  }
}
