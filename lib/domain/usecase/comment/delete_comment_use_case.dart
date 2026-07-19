import '../../repository/comment_repository.dart';

class DeleteCommentUseCase {
  final CommentRepository _commentRepository;

  DeleteCommentUseCase(this._commentRepository);

  Future<void> call(int commentId) async {
    await _commentRepository.deleteComment(commentId);
  }
}
