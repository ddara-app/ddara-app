import 'package:ddara/core/model/report/comment_report_reason.dart';
import 'package:ddara/core/model/report/report_reason.dart';

abstract interface class ReportRepository {
  Future<void> reportShot({
    required int shotId,
    required ReportReason reason,
    String? reasonText,
  });

  Future<void> reportComment({
    required int commentId,
    required CommentReportReason reason,
    String? reasonText,
  });
}
