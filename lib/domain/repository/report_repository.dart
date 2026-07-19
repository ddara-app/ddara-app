import 'package:ddara/core/model/report/report_reason.dart';
import 'package:ddara/core/model/report/user_report_reason.dart';

abstract interface class ReportRepository {
  Future<void> reportShot({
    required int shotId,
    required ReportReason reason,
    String? reasonText,
  });

  /// 유저를 신고한다. 대상이 속한 [groupId] 가 필수다.
  Future<void> reportUser({
    required int userId,
    required int groupId,
    required UserReportReason reason,
    String? reasonText,
  });
}
