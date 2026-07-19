import '../../repository/comment_repository.dart';

class EditCommentUseCase {
  final CommentRepository _commentRepository;

  EditCommentUseCase(this._commentRepository);

  /// 댓글을 수정하고, 수정된 내용을 반환한다.
  Future<String> call({required int commentId, required String content}) {
    return _commentRepository.editComment(commentId: commentId, content: content);
  }
}
