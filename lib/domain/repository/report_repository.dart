import 'package:ddara/core/model/report/report_reason.dart';

abstract interface class ReportRepository {
  Future<void> reportShot({
    required int shotId,
    required ReportReason reason,
    String? reasonText,
  });
}
