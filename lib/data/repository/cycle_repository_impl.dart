import 'package:ddara/core/exception/cycle_exception.dart';
import 'package:ddara/core/exception/follower_upload_error_code.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/starter_upload_error_code.dart';
import 'package:ddara/core/model/cycle/follower_upload.dart';
import 'package:ddara/core/model/cycle/starter_upload.dart';
import 'package:ddara/core/model/group/cycle_gallery.dart';
import 'package:ddara/core/network/dto/cycle/presign_response.dart';
import 'package:ddara/domain/repository/cycle_repository.dart';
import 'package:dio/dio.dart';

import '../datasource/cycle/cycle_datasource.dart';
import '../datasource/upload/upload_datasource.dart';
import 'mapper/cycle_mapper.dart';
import 'mapper/group_mapper.dart';

class CycleRepositoryImpl implements CycleRepository {
  CycleRepositoryImpl(this._cycleDataSource, this._uploadDataSource);

  final CycleDataSource _cycleDataSource;
  final UploadDataSource _uploadDataSource;

  static const String _contentType = 'image/jpeg';

  Future<PresignResponse> uploadImage(String path) async {
    final bytes = await _uploadDataSource.compress(path);

    // 1) presigned URL 발급 → 2) S3 직접 업로드.
    // (둘 다 사이클 생성 전 단계이므로 상태코드로 구분하지 않고 업로드 실패로 묶는다)
    final PresignResponse presign;
    try {
      presign = await _uploadDataSource.presign('shot', _contentType);
      await _uploadDataSource.uploadToS3(
        presign.uploadUrl,
        bytes,
        _contentType,
      );
      return presign;
    } on DioException {
      throw StarterImageUploadException();
    }
  }

  @override
  Future<StarterUpload> uploadStarter(
    int groupId,
    String topic,
    String path,
  ) async {
    final presign = await uploadImage(path);

    // 3) 업로드된 imageUrl로 사이클 생성.
    try {
      final response = await _cycleDataSource.createCycle(
        groupId,
        topic,
        presign.imageUrl,
      );

      return response.toDomain();
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? StarterUploadErrorCode.fromValue(e.response?.data['code'])
          : null;

      switch (code) {
        case StarterUploadErrorCode.invalidInput:
          // 400 — topic/imageUrl 누락 또는 topic 20자 초과
          throw InvalidStarterInputException();

        case StarterUploadErrorCode.unauthorized:
          // 401 — 토큰 없음·만료 (인터셉터 복구도 실패한 경우)
          throw UnauthorizedException();

        case StarterUploadErrorCode.notGroupMember:
          // 403 — 해당 모임의 멤버가 아님
          throw NotGroupMemberException();

        case StarterUploadErrorCode.groupNotFound:
          // 404 — 모임을 찾을 수 없음
          throw GroupNotFoundException();

        case StarterUploadErrorCode.notEnoughMembers:
          // 409 — 활동 멤버 3명 미만이라 시작 불가
          throw NotEnoughMembersException();

        case StarterUploadErrorCode.cycleAlreadyInProgress:
          // 409 — 이미 진행 중인 회차 존재
          throw CycleAlreadyInProgressException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<FollowerUpload> uploadFollower(int cycleId, String path) async {
    final presign = await uploadImage(path);

    // 업로드된 imageUrl로 따라찍기 사진을 등록한다.
    try {
      final response = await _cycleDataSource.uploadFollower(
        cycleId,
        presign.imageUrl,
      );

      return response.toDomain();
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? FollowerUploadErrorCode.fromValue(e.response?.data['code'])
          : null;

      switch (code) {
        case FollowerUploadErrorCode.notGroupMember:
          // 403 — 해당 모임의 멤버가 아님
          throw NotGroupMemberException();

        case FollowerUploadErrorCode.cycleNotFound:
          // 404 — 회차 없음
          throw CycleNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }

  @override
  Future<CycleGallery> getCycleGallery(int cycleId) async {
    try {
      final response = await _cycleDataSource.getCycleGallery(cycleId);
      return response.toDomain();
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 403:
          // 해당 모임의 멤버가 아님
          throw NotGroupMemberException();

        case 404:
          // 사이클(또는 모임) 없음
          throw GroupNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }
}
