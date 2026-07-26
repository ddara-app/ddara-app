import '../../repository/comment_repository.dart';

class MarkCommentsReadUseCase {
  final CommentRepository _commentRepository;

  MarkCommentsReadUseCase(this._commentRepository);

  /// [shotId] 사진의 댓글을 읽음 처리한다.
  ///
  /// 이후 갤러리 조회에서 해당 사진의 hasUnreadComments 가 false 로 내려와
  /// 댓글 버튼 강조가 사라진다.
  Future<void> call(int shotId) => _commentRepository.markCommentsRead(shotId);
}
