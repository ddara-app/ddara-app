import 'package:ddara/core/model/comment/comment.dart';

import '../../repository/comment_repository.dart';

class CreateCommentUseCase {
  final CommentRepository _commentRepository;

  CreateCommentUseCase(this._commentRepository);

  Future<Comment> call({required int shotId, required String content}) async {
    return _commentRepository.createComment(shotId: shotId, content: content);
  }
}
