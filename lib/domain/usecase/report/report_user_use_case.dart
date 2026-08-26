import 'package:ddara/domain/model/report/user_report_reason.dart';

import '../../repository/report_repository.dart';

class ReportUserUseCase {
  final ReportRepository _reportRepository;

  ReportUserUseCase(this._reportRepository);

  Future<void> call({
    required int userId,
    required int groupId,
    required UserReportReason reason,
    String? reasonText,
  }) async {
    await _reportRepository.reportUser(
      userId: userId,
      groupId: groupId,
      reason: reason,
      reasonText: reasonText,
    );
  }
}
