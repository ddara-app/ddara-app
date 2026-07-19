import 'package:ddara/core/model/report/comment_report_reason.dart';
import 'package:ddara/core/widget/bottom_sheet/report_reason_sheet.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 사유별 표시 라벨.
extension CommentReportReasonLabel on CommentReportReason {
  String label(AppLocalizations l10n) {
    switch (this) {
      case CommentReportReason.sexual:
        return l10n.commentReportReasonSexual;
      case CommentReportReason.violence:
        return l10n.commentReportReasonViolence;
      case CommentReportReason.abuse:
        return l10n.commentReportReasonAbuse;
      case CommentReportReason.harassment:
        return l10n.commentReportReasonHarassment;
      case CommentReportReason.etc:
        return l10n.commentReportReasonEtc;
    }
  }
}

/// 시트가 반환하는 신고 내용.
/// (선택한 사유 + 상세 입력 — 상세는 '기타' 사유일 때만 채워진다)
typedef CommentReportResult = ({CommentReportReason reason, String detail});

/// 댓글 신고 사유를 선택하는 바텀시트. (사진 신고와 동일한 디자인, 사유만 다름)
///
/// 공통 [ReportReasonSheet] 에 댓글 신고 사유를 넣어 띄운다. 확정하면
/// [CommentReportResult] 를, 취소·바깥 탭이면 null 을 반환한다.
class CommentReportSheet {
  const CommentReportSheet._();

  /// 바텀시트를 띄우고 확정한 신고 내용을 받는다. 취소·바깥 탭이면 null.
  static Future<CommentReportResult?> show(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final result = await ReportReasonSheet.show(
      context,
      title: l10n.photoReportSheetTitle,
      subtitle: l10n.photoReportSheetSubtitle,
      submitLabel: l10n.photoReport,
      detailPlaceholder: l10n.photoReportDetailPlaceholder,
      reasons: [
        for (final reason in CommentReportReason.values)
          ReportReasonOption(
            label: reason.label(l10n),
            requiresDetail: reason == CommentReportReason.etc,
          ),
      ],
    );
    if (result == null) return null;
    return (
      reason: CommentReportReason.values[result.index],
      detail: result.detail,
    );
  }
}
