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

  /// [shotId] 사진의 댓글 목록을 조회한다.
  Future<CommentListResponse> getComments(int shotId) async {
    final response = await _dio.get('/api/shots/$shotId/comments');

    return CommentListResponse.fromJson(response.data);
  }

  /// [shotId] 사진의 댓글을 읽음 처리한다. (응답 본문 없음)
  Future<void> markCommentsRead(int shotId) async {
    await _dio.post('/api/shots/$shotId/comments/read');
  }

  /// [commentId] 댓글을 삭제한다. (응답 본문 없음)
  Future<void> deleteComment(int commentId) async {
    await _dio.delete('/api/comments/$commentId');
  }

  /// [commentId] 댓글의 내용을 [content] 로 수정하고, 수정 결과를 반환한다.
  Future<CommentUpdateResponse> editComment({
    required int commentId,
    required String content,
  }) async {
    final response = await _dio.patch(
      '/api/comments/$commentId',
      data: {'content': content},
    );

    return CommentUpdateResponse.fromJson(response.data);
  }
}
