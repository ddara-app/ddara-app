import 'package:ddara/core/model/report/report_reason.dart';
import 'package:ddara/core/widget/bottom_sheet/report_reason_sheet.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 사유별 표시 라벨.
extension ReportReasonLabel on ReportReason {
  String label(AppLocalizations l10n) {
    switch (this) {
      case ReportReason.obscene:
        return l10n.photoReportReasonObscene;
      case ReportReason.violence:
        return l10n.photoReportReasonViolence;
      case ReportReason.unauthorizedPhoto:
        return l10n.photoReportReasonUnauthorizedFilming;
      case ReportReason.harassment:
        return l10n.photoReportReasonImpersonation;
      case ReportReason.etc:
        return l10n.photoReportReasonEtc;
    }
  }
}

/// 시트가 반환하는 사진 신고 내용.
typedef PhotoReportResult = ReportSheetResult<ReportReason>;

/// 사진 신고 사유를 선택하는 바텀시트.
///
/// 사유 목록만 사진용으로 채운 [ReportReasonSheet] 이다.
abstract final class PhotoReportSheet {
  /// 바텀시트를 띄우고 확정한 신고 내용을 받는다. 취소·바깥 탭이면 null.
  static Future<PhotoReportResult?> show(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ReportReasonSheet.show<ReportReason>(
      context,
      reasons: ReportReason.values,
      labelOf: (reason) => reason.label(l10n),
      etcReason: ReportReason.etc,
    );
  }
}
