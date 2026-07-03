import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/profile_error_code.dart';
import 'package:ddara/core/exception/profile_exception.dart';
import 'package:ddara/core/model/profile/notification_settings.dart';
import 'package:ddara/core/model/profile/profile.dart';
import 'package:ddara/data/datasource/profile/profile_datasource.dart';
import 'package:ddara/data/repository/mapper/profile_mapper.dart';
import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:dio/dio.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._profileDataSource);

  final ProfileDataSource _profileDataSource;

  @override
  Future<Profile> getProfile() async {
    try {
      final response = await _profileDataSource.getProfile();
      return response.toDomain();
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? ProfileErrorCode.fromValue(e.response?.data['code'])
          : null;

      // 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      switch (code) {
        case ProfileErrorCode.userNotFound:
          // 404 — 사용자를 찾을 수 없음
          throw UserNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<void> deleteAccount() async {
    await _profileDataSource.deleteAccount();
  }

  @override
  Future<String> uploadProfileImage(String imagePath) async {
    try {
      final response = await _profileDataSource.uploadProfileImage(imagePath);
      return response.profileImageUrl;
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? ProfileErrorCode.fromValue(e.response?.data['code'])
          : null;

      // 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      switch (code) {
        case ProfileErrorCode.invalidImageFile:
          // 400 — jpg/png 가 아닌 형식
          throw InvalidImageFileException();

        case ProfileErrorCode.userNotFound:
          // 404 — 사용자를 찾을 수 없음
          throw UserNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<NotificationSettings> changeNotificationSettings(
    NotificationSettings settings,
  ) async {
    final response = await _profileDataSource.changeNotificationSettings(
      settings.toRequest(),
    );
    return response.toDomain();
  }

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    final response = await _profileDataSource.getNotificationSettings();
    return response.toDomain();
  }
}
