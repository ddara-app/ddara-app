import 'package:ddara/core/model/report/group_report_reason.dart';
import 'package:ddara/core/widget/bottom_sheet/report_reason_sheet.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 사유별 표시 라벨.
extension GroupReportReasonLabel on GroupReportReason {
  String label(AppLocalizations l10n) {
    switch (this) {
      case GroupReportReason.inappropriateGroup:
        return l10n.groupReportReasonInappropriate;
      case GroupReportReason.etc:
        return l10n.groupReportReasonEtc;
    }
  }
}

/// 시트가 반환하는 모임 신고 내용.
typedef GroupReportResult = ReportSheetResult<GroupReportReason>;

/// 모임 신고 사유를 선택하는 바텀시트.
///
/// 사유 목록만 모임용으로 채운 [ReportReasonSheet] 이다.
abstract final class GroupReportSheet {
  /// 바텀시트를 띄우고 확정한 신고 내용을 받는다. 취소·바깥 탭이면 null.
  static Future<GroupReportResult?> show(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ReportReasonSheet.show<GroupReportReason>(
      context,
      reasons: GroupReportReason.values,
      labelOf: (reason) => reason.label(l10n),
      etcReason: GroupReportReason.etc,
    );
  }
}
