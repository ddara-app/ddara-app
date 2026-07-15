import 'package:ddara/core/network/dto/cycle/follower_upload_response.dart';
import 'package:ddara/core/network/dto/cycle/starter_upload_response.dart';
import 'package:ddara/core/network/dto/group/cycle_gallery_response.dart';
import 'package:dio/dio.dart';

class CycleDataSource {
  CycleDataSource(this._dio);

  final Dio _dio;
  static final String _baseUrl = '/api/groups';

  /// 업로드된 이미지 URL로 새 사이클을 생성한다.
  Future<StarterUploadResponse> createCycle(
    int groupId,
    String topic,
    String imageUrl,
  ) async {
    final response = await _dio.post(
      '$_baseUrl/$groupId/cycles',
      data: {'topic': topic, 'imageUrl': imageUrl},
    );

    return StarterUploadResponse.fromJson(response.data);
  }

  /// 사이클의 멤버별 따라찍기 사진(shots)을 조회한다.
  Future<CycleGalleryResponse> getCycleGallery(int cycleId) async {
    final response = await _dio.get('/api/cycles/$cycleId/shots');

    return CycleGalleryResponse.fromJson(response.data);
  }

  /// 업로드된 이미지 URL로 따라찍기(팔로워) 사진을 등록한다.
  Future<FollowerUploadResponse> uploadFollower(
    int cycleId,
    String imageUrl,
  ) async {
    final response = await _dio.post(
      '/api/cycles/$cycleId/shots',
      data: {'imageUrl': imageUrl},
    );

    return FollowerUploadResponse.fromJson(response.data);
  }
}
