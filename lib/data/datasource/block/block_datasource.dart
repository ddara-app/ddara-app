import 'package:ddara/core/network/dto/block/block_list_response.dart';
import 'package:dio/dio.dart';

class BlockDataSource {
  BlockDataSource(this._dio);

  final Dio _dio;
  static final String _baseUrl = '/api/blocks';

  /// [userId] 사용자를 [groupId] 모임 맥락에서 차단한다. (응답 본문 없음)
  Future<void> blockUser(int userId, {required int groupId}) async {
    await _dio.post(_baseUrl, data: {'userId': userId, 'groupId': groupId});
  }

  /// 내가 차단한 사용자 목록을 조회한다.
  Future<BlockListResponse> getBlocks() async {
    final response = await _dio.get(_baseUrl);

    return BlockListResponse.fromJson(response.data);
  }

  /// [userId] 사용자의 차단을 해제한다. (응답 본문 없음)
  Future<void> unblockUser(int userId) async {
    await _dio.delete('$_baseUrl/$userId');
  }
}
