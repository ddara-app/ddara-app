import 'package:ddara/core/model/report/report_reason.dart';

import '../../repository/report_repository.dart';

class ReportShotUseCase {
  final ReportRepository _reportRepository;

  ReportShotUseCase(this._reportRepository);

  Future<void> call({
    required int shotId,
    required ReportReason reason,
    String? reasonText,
  }) async {
    await _reportRepository.reportShot(
      shotId: shotId,
      reason: reason,
      reasonText: reasonText,
    );
  }
}
