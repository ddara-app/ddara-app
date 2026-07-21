import 'package:ddara/core/model/report/group_report_reason.dart';

import '../../repository/report_repository.dart';

class ReportGroupUseCase {
  final ReportRepository _reportRepository;

  ReportGroupUseCase(this._reportRepository);

  Future<void> call({
    required int groupId,
    required GroupReportReason reason,
    String? reasonText,
  }) async {
    await _reportRepository.reportGroup(
      groupId: groupId,
      reason: reason,
      reasonText: reasonText,
    );
  }
}
