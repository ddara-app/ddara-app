import 'dart:typed_data';

import 'package:ddara/core/exception/cycle_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/network/dto/cycle/presign_response.dart';
import 'package:ddara/core/network/dto/cycle/starter_upload_response.dart';
import 'package:ddara/core/network/dto/group/cycle_gallery_response.dart';
import 'package:ddara/data/datasource/cycle/cycle_datasource.dart';
import 'package:ddara/data/datasource/upload/upload_datasource.dart';
import 'package:ddara/data/repository/cycle_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCycleDataSource extends Mock implements CycleDataSource {}

class MockUploadDataSource extends Mock implements UploadDataSource {}

DioException _dioError({String? code, int? statusCode}) {
  final req = RequestOptions(path: '/api/groups/1/cycles');
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: statusCode ?? 400,
      data: code == null ? null : {'code': code},
    ),
  );
}

void main() {
  late MockCycleDataSource cycleDataSource;
  late MockUploadDataSource uploadDataSource;
  late CycleRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(UploadImageFormat.jpeg);
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    cycleDataSource = MockCycleDataSource();
    uploadDataSource = MockUploadDataSource();
    repository = CycleRepositoryImpl(cycleDataSource, uploadDataSource);

    when(
      () => uploadDataSource.compress(
        any(),
        maxSize: any(named: 'maxSize'),
        quality: any(named: 'quality'),
        format: any(named: 'format'),
      ),
    ).thenAnswer((_) async => Uint8List(0));
    when(() => uploadDataSource.seedImageCache(any(), any())).thenAnswer((_) async {});
    when(() => uploadDataSource.deleteTempFile(any())).thenAnswer((_) async {});
  });

  void stubPresignSuccess() {
    when(() => uploadDataSource.presign(any(), any())).thenAnswer(
      (_) async => const PresignResponse(
        uploadUrl: 'https://s3/put',
        imageUrl: 'https://s3/final.jpg',
        expiresIn: 60,
      ),
    );
    when(() => uploadDataSource.uploadToS3(any(), any(), any())).thenAnswer((_) async {});
  }

  group('uploadStarter', () {
    test('presign 단계가 실패하면 StarterImageUploadException 으로 변환한다', () async {
      when(() => uploadDataSource.presign(any(), any())).thenThrow(_dioError());

      expect(
        () => repository.uploadStarter(1, 'topic', '/path'),
        throwsA(isA<StarterImageUploadException>()),
      );
    });

    test('업로드 성공 후 CYCLE_ALREADY_IN_PROGRESS 코드는 해당 예외로 변환한다', () async {
      stubPresignSuccess();
      when(
        () => cycleDataSource.createCycle(any(), any(), any()),
      ).thenThrow(_dioError(code: 'CYCLE_ALREADY_IN_PROGRESS'));

      expect(
        () => repository.uploadStarter(1, 'topic', '/path'),
        throwsA(isA<CycleAlreadyInProgressException>()),
      );
    });

    test('사이클 생성이 성공하면 캐시 시딩·임시파일 삭제 후결과를 반환한다', () async {
      stubPresignSuccess();
      when(() => cycleDataSource.createCycle(1, 'topic', 'https://s3/final.jpg')).thenAnswer(
        (_) async => StarterUploadResponse(
          cycleId: 1,
          groupId: 1,
          cycleNumber: 1,
          topic: 'topic',
          starterUserId: 1,
          status: 'in_progress',
          startedAt: DateTime(2026, 1, 1),
          deadlineAt: DateTime(2026, 1, 2),
          starterShot: const StarterShotResponse(
            shotId: 1,
            imageUrl: 'https://s3/final.jpg',
            type: 'starter',
          ),
        ),
      );

      final result = await repository.uploadStarter(1, 'topic', '/path');

      expect(result.cycleId, 1);
      verify(() => uploadDataSource.seedImageCache('https://s3/final.jpg', any())).called(1);
      verify(() => uploadDataSource.deleteTempFile('/path')).called(1);
    });
  });

  group('uploadFollower', () {
    test('CYCLE_NOT_FOUND 코드는 CycleNotFoundException 으로 변환한다', () async {
      stubPresignSuccess();
      when(
        () => cycleDataSource.uploadFollower(any(), any()),
      ).thenThrow(_dioError(code: 'CYCLE_NOT_FOUND'));

      expect(
        () => repository.uploadFollower(1, '/path'),
        throwsA(isA<CycleNotFoundException>()),
      );
    });

    test('매칭되지 않는 code 는 NetworkException 으로 변환한다', () async {
      stubPresignSuccess();
      when(
        () => cycleDataSource.uploadFollower(any(), any()),
      ).thenThrow(_dioError());

      expect(
        () => repository.uploadFollower(1, '/path'),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('getCycleGallery', () {
    test('403 이면 NotGroupMemberException 으로 변환한다', () async {
      when(
        () => cycleDataSource.getCycleGallery(any()),
      ).thenThrow(_dioError(statusCode: 403));

      expect(
        () => repository.getCycleGallery(1),
        throwsA(isA<NotGroupMemberException>()),
      );
    });

    test('404 이면 GroupNotFoundException 으로 변환한다', () async {
      when(
        () => cycleDataSource.getCycleGallery(any()),
      ).thenThrow(_dioError(statusCode: 404));

      expect(
        () => repository.getCycleGallery(1),
        throwsA(isA<GroupNotFoundException>()),
      );
    });

    test('그 외 상태코드는 NetworkException 으로 변환한다', () async {
      when(
        () => cycleDataSource.getCycleGallery(any()),
      ).thenThrow(_dioError(statusCode: 500));

      expect(
        () => repository.getCycleGallery(1),
        throwsA(isA<NetworkException>()),
      );
    });

    test('성공하면 응답을 도메인 모델로 변환한다', () async {
      when(() => cycleDataSource.getCycleGallery(1)).thenAnswer(
        (_) async => CycleGalleryResponse(
          groupId: 1,
          groupName: 'group',
          cycle: CycleGalleryCycleResponse(
            cycleId: 1,
            cycleNumber: 1,
            topic: 'topic',
            starterUserId: 1,
            starterNickname: 'starter',
            starterShotId: 1,
            starterImageUrl: null,
            starterImageUnderReview: false,
            status: 'in_progress',
            deadlineAt: DateTime(2026, 1, 2),
          ),
          viewerUploaded: false,
          members: const [],
        ),
      );

      final result = await repository.getCycleGallery(1);

      expect(result.groupId, 1);
    });
  });
}
