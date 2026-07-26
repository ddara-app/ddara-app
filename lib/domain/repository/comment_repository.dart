import 'package:ddara/core/model/comment/comment.dart';

abstract interface class CommentRepository {
  /// [shotId] 사진에 댓글을 등록하고, 생성된 댓글을 반환한다.
  Future<Comment> createComment({required int shotId, required String content});

  /// [shotId] 사진의 댓글 목록을 조회한다.
  Future<List<Comment>> getComments(int shotId);

  /// [shotId] 사진의 댓글을 읽음 처리한다.
  /// (이후 조회에서 해당 사진의 hasUnreadComments 가 false 로 내려온다)
  Future<void> markCommentsRead(int shotId);

  /// [commentId] 댓글을 삭제한다.
  Future<void> deleteComment(int commentId);

  /// [commentId] 댓글의 내용을 [content] 로 수정하고, 수정된 내용을 반환한다.
  Future<String> editComment({required int commentId, required String content});
}
