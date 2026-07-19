import 'package:ddara/core/model/comment/comment.dart';

abstract interface class CommentRepository {
  /// [shotId] 사진에 댓글을 등록하고, 생성된 댓글을 반환한다.
  Future<Comment> createComment({required int shotId, required String content});

  /// [shotId] 사진의 댓글 목록을 조회한다.
  Future<List<Comment>> getComments(int shotId);
}
