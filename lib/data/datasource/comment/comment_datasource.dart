import 'package:ddara/core/network/dto/comment/comment_response.dart';
import 'package:dio/dio.dart';

class CommentDataSource {
  CommentDataSource(this._dio);

  final Dio _dio;

  /// [shotId] 사진에 댓글을 등록하고, 생성된 댓글을 반환한다.
  Future<CommentResponse> createComment({
    required int shotId,
    required String content,
  }) async {
    final response = await _dio.post(
      '/api/shots/$shotId/comments',
      data: {'content': content},
    );

    return CommentResponse.fromJson(response.data);
  }
}
