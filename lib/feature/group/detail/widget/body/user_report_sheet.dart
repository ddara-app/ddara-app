import 'package:ddara/core/model/report/user_report_reason.dart';
import 'package:ddara/core/widget/report_reason_sheet.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 사유별 표시 라벨.
extension UserReportReasonLabel on UserReportReason {
  String label(AppLocalizations l10n) {
    switch (this) {
      case UserReportReason.nickname:
        return l10n.userReportReasonNickname;
      case UserReportReason.profileImage:
        return l10n.userReportReasonProfileImage;
      case UserReportReason.harassment:
        return l10n.userReportReasonHarassment;
      case UserReportReason.etc:
        return l10n.userReportReasonEtc;
    }
  }
}

/// 시트가 반환하는 유저 신고 내용.
typedef UserReportResult = ReportSheetResult<UserReportReason>;

/// 유저 신고 사유를 선택하는 바텀시트.
///
/// 사유 목록만 유저용으로 채운 [ReportReasonSheet] 이다.
abstract final class UserReportSheet {
  /// 바텀시트를 띄우고 확정한 신고 내용을 받는다. 취소·바깥 탭이면 null.
  static Future<UserReportResult?> show(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ReportReasonSheet.show<UserReportReason>(
      context,
      reasons: UserReportReason.values,
      labelOf: (reason) => reason.label(l10n),
      etcReason: UserReportReason.etc,
    );
  }
}