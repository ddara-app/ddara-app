import 'package:ddara/domain/model/report/group_report_reason.dart';
import 'package:ddara/domain/model/report/report_reason.dart';
import 'package:ddara/domain/model/report/user_report_reason.dart';
import 'package:ddara/core/widget/bottom_sheet/report_reason_sheet.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// 신고 대상별 사유 시트.
///
/// 시트 UI·선택 로직은 [ReportReasonSheet] 하나가 담당하고, 여기서는 대상마다
/// 다른 "사유 목록 + 기타 사유"만 채워 넣는다. 표시 라벨은 각 사유 enum 옆의
/// `label(l10n)` extension 에 있다.

/// 시트가 반환하는 사진 신고 내용.
typedef PhotoReportResult = ReportSheetResult<ReportReason>;

/// 시트가 반환하는 유저 신고 내용.
typedef UserReportResult = ReportSheetResult<UserReportReason>;

/// 시트가 반환하는 모임 신고 내용.
typedef GroupReportResult = ReportSheetResult<GroupReportReason>;

/// 사진 신고 사유를 선택하는 바텀시트.
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

/// 유저 신고 사유를 선택하는 바텀시트.
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

/// 모임 신고 사유를 선택하는 바텀시트.
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
