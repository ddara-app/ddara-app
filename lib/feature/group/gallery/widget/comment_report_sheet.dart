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

/// 시트가 반환하는 댓글 신고 내용.
typedef CommentReportResult = ReportSheetResult<CommentReportReason>;

/// 댓글 신고 사유를 선택하는 바텀시트.
///
/// 사유 목록만 댓글용으로 채운 [ReportReasonSheet] 이다.
abstract final class CommentReportSheet {
  /// 바텀시트를 띄우고 확정한 신고 내용을 받는다. 취소·바깥 탭이면 null.
  static Future<CommentReportResult?> show(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ReportReasonSheet.show<CommentReportReason>(
      context,
      reasons: CommentReportReason.values,
      labelOf: (reason) => reason.label(l10n),
      etcReason: CommentReportReason.etc,
    );
  }
}
