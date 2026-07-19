import 'package:ddara/core/model/comment/comment.dart';

import '../../repository/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository _commentRepository;

  GetCommentsUseCase(this._commentRepository);

  Future<List<Comment>> call(int shotId) async {
    return _commentRepository.getComments(shotId);
  }
}
