import 'dart:typed_data';

import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/profile_exception.dart';
import 'package:ddara/core/network/dto/cycle/presign_response.dart';
import 'package:ddara/core/network/dto/profile/camera_guide_response.dart';
import 'package:ddara/core/network/dto/profile/notification_settings_response.dart';
import 'package:ddara/core/network/dto/profile/profile_image_response.dart';
import 'package:ddara/core/network/dto/profile/profile_response.dart';
import 'package:ddara/data/datasource/profile/profile_datasource.dart';
import 'package:ddara/data/datasource/upload/upload_datasource.dart';
import 'package:ddara/data/repository/profile_repository_impl.dart';
import 'package:ddara/domain/model/camera/camera_guide_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileDataSource extends Mock implements ProfileDataSource {}

class MockUploadDataSource extends Mock implements UploadDataSource {}

DioException _dioError({String? code}) {
  final req = RequestOptions(path: '/api/users/me');
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: 400,
      data: code == null ? null : {'code': code},
    ),
  );
}

void main() {
  late MockProfileDataSource profileDataSource;
  late MockUploadDataSource uploadDataSource;
  late ProfileRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(UploadImageFormat.jpeg);
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    profileDataSource = MockProfileDataSource();
    uploadDataSource = MockUploadDataSource();
    repository = ProfileRepositoryImpl(profileDataSource, uploadDataSource);
  });

  group('getProfile', () {
    test('응답을 도메인 모델로 변환한다', () async {
      when(() => profileDataSource.getProfile()).thenAnswer(
        (_) async => ProfileResponse(
          id: 1,
          name: 'kim',
          profileImageUrl: null,
          provider: 'KAKAO',
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      final result = await repository.getProfile();

      expect(result.id, 1);
    });

    test('USER_NOT_FOUND 코드는 UserNotFoundException 으로 변환한다', () async {
      when(() => profileDataSource.getProfile()).thenThrow(_dioError(code: 'USER_NOT_FOUND'));

      expect(() => repository.getProfile(), throwsA(isA<UserNotFoundException>()));
    });
  });

  group('deleteAccount', () {
    test('appleAuthorizationCode 를 그대로 DataSource 에 위임한다', () async {
      when(
        () => profileDataSource.deleteAccount(
          appleAuthorizationCode: any(named: 'appleAuthorizationCode'),
        ),
      ).thenAnswer((_) async {});

      await repository.deleteAccount(appleAuthorizationCode: 'code');

      verify(
        () => profileDataSource.deleteAccount(appleAuthorizationCode: 'code'),
      ).called(1);
    });

    test('매칭되지 않는 code 는 NetworkException 으로 변환한다', () async {
      when(
        () => profileDataSource.deleteAccount(
          appleAuthorizationCode: any(named: 'appleAuthorizationCode'),
        ),
      ).thenThrow(_dioError());

      expect(() => repository.deleteAccount(), throwsA(isA<NetworkException>()));
    });
  });

  group('uploadProfileImage', () {
    void stubHappyPath() {
      when(
        () => uploadDataSource.compress(
          any(),
          maxSize: any(named: 'maxSize'),
          format: any(named: 'format'),
        ),
      ).thenAnswer((_) async => Uint8List(0));
      when(
        () => uploadDataSource.presign(any(), any()),
      ).thenAnswer(
        (_) async => const PresignResponse(
          uploadUrl: 'https://s3/put',
          imageUrl: 'https://s3/final.jpg',
          expiresIn: 60,
        ),
      );
      when(
        () => uploadDataSource.uploadToS3(any(), any(), any()),
      ).thenAnswer((_) async {});
      when(
        () => uploadDataSource.seedImageCache(any(), any()),
      ).thenAnswer((_) async {});
      when(() => uploadDataSource.deleteTempFile(any())).thenAnswer((_) async {});
    }

    test('압축 → presign → S3 업로드 → 프로필 갱신 순서로 진행해 새 URL 을 반환한다', () async {
      stubHappyPath();
      when(
        () => profileDataSource.updateProfileImage('https://s3/final.jpg'),
      ).thenAnswer(
        (_) async => const ProfileImageResponse(profileImageUrl: 'https://s3/final.jpg'),
      );

      final result = await repository.uploadProfileImage('/local/path.jpg');

      expect(result, 'https://s3/final.jpg');
      verify(() => uploadDataSource.seedImageCache('https://s3/final.jpg', any())).called(1);
      verify(() => uploadDataSource.deleteTempFile('/local/path.jpg')).called(1);
    });

    test('presign·S3 업로드 단계의 DioException 은 NetworkException 으로 변환한다', () async {
      when(
        () => uploadDataSource.compress(
          any(),
          maxSize: any(named: 'maxSize'),
          format: any(named: 'format'),
        ),
      ).thenAnswer((_) async => Uint8List(0));
      when(
        () => uploadDataSource.presign(any(), any()),
      ).thenThrow(_dioError());

      expect(
        () => repository.uploadProfileImage('/local/path.jpg'),
        throwsA(isA<NetworkException>()),
      );
    });

    test('프로필 갱신 단계에서 INVALID_IMAGE_FILE 코드는 InvalidImageFileException 으로 변환한다', () async {
      stubHappyPath();
      when(
        () => profileDataSource.updateProfileImage(any()),
      ).thenThrow(_dioError(code: 'INVALID_IMAGE_FILE'));

      expect(
        () => repository.uploadProfileImage('/local/path.jpg'),
        throwsA(isA<InvalidImageFileException>()),
      );
    });
  });

  group('resetProfileImage', () {
    test('DataSource 호출을 그대로 위임한다', () async {
      when(() => profileDataSource.resetProfileImage()).thenAnswer((_) async {});

      await repository.resetProfileImage();

      verify(() => profileDataSource.resetProfileImage()).called(1);
    });
  });

  group('getSeenCameraGuides', () {
    test('알려진 키만 CameraGuideKey 로 변환하고 모르는 키는 걸러낸다', () async {
      when(() => profileDataSource.getCameraGuide()).thenAnswer(
        (_) async => const CameraGuideResponse(seen: ['MINI_VIEW', 'SOME_NEW_GUIDE']),
      );

      final result = await repository.getSeenCameraGuides();

      expect(result, {CameraGuideKey.miniView});
    });
  });

  group('completeCameraGuide', () {
    test('key 문자열 값으로 변환해 DataSource 에 위임한다', () async {
      when(
        () => profileDataSource.completeCameraGuide(any()),
      ).thenAnswer((_) async {});

      await repository.completeCameraGuide(CameraGuideKey.ghostView);

      verify(
        () => profileDataSource.completeCameraGuide(CameraGuideKey.ghostView.value),
      ).called(1);
    });

    test('INVALID_INPUT 코드는 InvalidInputException 으로 변환한다', () async {
      when(
        () => profileDataSource.completeCameraGuide(any()),
      ).thenThrow(_dioError(code: 'INVALID_INPUT'));

      expect(
        () => repository.completeCameraGuide(CameraGuideKey.miniView),
        throwsA(isA<InvalidInputException>()),
      );
    });
  });

  group('getNotificationSettings / changeNotificationSettings', () {
    test('getNotificationSettings 는 응답을 도메인 모델로 변환한다', () async {
      when(() => profileDataSource.getNotificationSettings()).thenAnswer(
        (_) async => const NotificationSettingsResponse(
          allowAll: true,
          activity: ActivityNotificationResponse(
            followShot: true,
            friendShot: true,
            starterAssigned: true,
            comment: true,
          ),
          etc: EtcNotificationResponse(memberJoin: true),
        ),
      );

      final result = await repository.getNotificationSettings();

      expect(result.allowAll, true);
    });
  });
}
