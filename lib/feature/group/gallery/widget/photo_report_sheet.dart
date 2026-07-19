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

/// 시트가 반환하는 신고 내용.
/// (선택한 사유 + 상세 입력 — 상세는 '기타' 사유일 때만 채워진다)
typedef PhotoReportResult = ({ReportReason reason, String detail});

/// 사진 신고 사유를 선택하는 바텀시트.
///
/// 공통 [ReportReasonSheet] 에 사진 신고 사유를 넣어 띄운다. 확정하면
/// [PhotoReportResult] 를, 취소·바깥 탭이면 null 을 반환한다.
class PhotoReportSheet {
  const PhotoReportSheet._();

  /// 바텀시트를 띄우고 확정한 신고 내용을 받는다. 취소·바깥 탭이면 null.
  static Future<PhotoReportResult?> show(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final result = await ReportReasonSheet.show(
      context,
      title: l10n.photoReportSheetTitle,
      subtitle: l10n.photoReportSheetSubtitle,
      submitLabel: l10n.photoReport,
      detailPlaceholder: l10n.photoReportDetailPlaceholder,
      reasons: [
        for (final reason in ReportReason.values)
          ReportReasonOption(
            label: reason.label(l10n),
            requiresDetail: reason == ReportReason.etc,
          ),
      ],
    );
    if (result == null) return null;
    return (reason: ReportReason.values[result.index], detail: result.detail);
  }
}
