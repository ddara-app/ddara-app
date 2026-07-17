import 'package:dio/dio.dart';

class BlockDataSource {
  BlockDataSource(this._dio);

  final Dio _dio;
  static final String _baseUrl = '/api/blocks';

  /// [userId] 사용자를 차단한다. (응답 본문 없음)
  Future<void> blockUser(int userId) async {
    await _dio.post(_baseUrl, data: {'userId': userId});
  }
}
