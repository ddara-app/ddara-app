import 'package:ddara/core/model/report/comment_report_reason.dart';

import '../../repository/report_repository.dart';

class ReportCommentUseCase {
  final ReportRepository _reportRepository;

  ReportCommentUseCase(this._reportRepository);

  Future<void> call({
    required int commentId,
    required CommentReportReason reason,
    String? reasonText,
  }) async {
    await _reportRepository.reportComment(
      commentId: commentId,
      reason: reason,
      reasonText: reasonText,
    );
  }
}
