import 'package:ddara/core/model/comment/comment.dart';

import '../../repository/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository _commentRepository;

  GetCommentsUseCase(this._commentRepository);

  /// [shotId] 사진의 댓글 목록을 조회한다.
  ///
  /// 검토 중(underReview)이거나 내가 신고한(reportedByMe) 댓글은 화면에
  /// 보여주지 않으므로 목록에서 제외한다. (차단 유저 필터는 화면별 상태를
  /// 알아야 해서 호출 측이 처리)
  Future<List<Comment>> call(int shotId) async {
    final comments = await _commentRepository.getComments(shotId);
    return comments
        .where((comment) => !comment.underReview && !comment.reportedByMe)
        .toList();
  }
}
