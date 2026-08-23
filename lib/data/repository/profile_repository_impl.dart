import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/profile_error_code.dart';
import 'package:ddara/core/exception/profile_exception.dart';
import 'package:ddara/domain/model/camera/camera_guide_key.dart';
import 'package:ddara/domain/model/profile/notification_settings.dart';
import 'package:ddara/domain/model/profile/profile.dart';
import 'package:ddara/core/network/dto/cycle/presign_response.dart';
import 'package:ddara/data/datasource/profile/profile_datasource.dart';
import 'package:ddara/data/datasource/upload/upload_datasource.dart';
import 'package:ddara/data/repository/mapper/profile_mapper.dart';
import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:dio/dio.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._profileDataSource, this._uploadDataSource);

  final ProfileDataSource _profileDataSource;
  final UploadDataSource _uploadDataSource;

  /// presign 시 프로필 이미지를 구분하는 purpose 값.
  static const String _uploadPurpose = 'profile';

  /// 프로필 이미지 업로드 포맷. (테스트: JPEG 압축 — 용량 최소화)
  static const UploadImageFormat _uploadFormat = UploadImageFormat.jpeg;

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
  Future<void> deleteAccount({String? appleAuthorizationCode}) async {
    try {
      await _profileDataSource.deleteAccount(
        appleAuthorizationCode: appleAuthorizationCode,
      );
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? ProfileErrorCode.fromValue(e.response?.data['code'])
          : null;

      // 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      switch (code) {
        case ProfileErrorCode.userNotFound:
          // 404 — 사용자를 찾을 수 없음 (이미 탈퇴한 계정 포함)
          throw UserNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<String> uploadProfileImage(String imagePath) async {
    // 업로드 전 리사이징·압축은 공용 UploadDataSource.compress 로 통일한다.
    final bytes = await _uploadDataSource.compress(
      imagePath,
      maxSize: 512,
      format: _uploadFormat,
    );
    final contentType = _uploadFormat.contentType;

    // 1) presigned URL 발급 → 2) S3 직접 업로드. (실패는 업로드 오류로 묶는다)
    final PresignResponse presign;
    try {
      presign = await _uploadDataSource.presign(_uploadPurpose, contentType);
      await _uploadDataSource.uploadToS3(presign.uploadUrl, bytes, contentType);
    } on DioException {
      throw NetworkException();
    }

    // 3) 업로드된 imageUrl로 프로필 이미지 갱신.
    try {
      final response = await _profileDataSource.updateProfileImage(
        presign.imageUrl,
      );

      // 업로드 성공 후처리 — 방금 올린 바이트를 새 URL 의 캐시로 심어
      // (같은 URL 덮어쓰기 대비 메모리 캐시 비움 포함) 재다운로드 없이 바로
      // 보이게 하고, 크롭 임시 파일을 삭제한다. (실패는 무시)
      final newUrl = response.profileImageUrl;
      await _uploadDataSource.seedImageCache(newUrl, bytes);
      await _uploadDataSource.deleteTempFile(imagePath);
      return newUrl;
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
  Future<void> resetProfileImage() async {
    try {
      await _profileDataSource.resetProfileImage();
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

  @override
  Future<Set<CameraGuideKey>> getSeenCameraGuides() async {
    try {
      final response = await _profileDataSource.getCameraGuide();
      // 앱이 모르는 키가 늘어도 조회가 실패하지 않게 걸러낸다.
      return response.seen
          .map(CameraGuideKey.fromValue)
          .nonNulls
          .toSet();
    } on DioException catch (e) {
      throw _cameraGuideError(e);
    }
  }

  @override
  Future<void> completeCameraGuide(CameraGuideKey key) async {
    try {
      await _profileDataSource.completeCameraGuide(key.value);
    } on DioException catch (e) {
      throw _cameraGuideError(e);
    }
  }

  /// 가이드 조회·기록의 서버 오류를 도메인 예외로 바꾼다.
  ///
  /// 401(UNAUTHORIZED)은 인터셉터가 따로 처리하므로 여기서 다루지 않는다.
  Exception _cameraGuideError(DioException e) {
    final code = e.response?.data is Map
        ? ProfileErrorCode.fromValue(e.response?.data['code'])
        : null;

    return switch (code) {
      // 404 — 사용자를 찾을 수 없음
      ProfileErrorCode.userNotFound => UserNotFoundException(),
      // 400 — key 누락/빈 값
      ProfileErrorCode.invalidInput => InvalidInputException(),
      _ => NetworkException(),
    };
  }
}
