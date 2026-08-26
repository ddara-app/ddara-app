import 'package:ddara/l10n/app_localizations.dart';

/// 모임 신고 사유.
/// (`POST /api/reports` 의 targetType=GROUP 에서 허용되는 reasonCode 와 1:1 매핑)
enum GroupReportReason {
  /// 부적절한 모임 이름·이미지. (욕설·음란·혐오)
  inappropriateGroup('INAPPROPRIATE_GROUP'),

  /// 기타. (신고 시 상세 내용(reasonText)이 필수)
  etc('ETC');

  const GroupReportReason(this.code);

  /// 서버로 보내는 reasonCode 문자열.
  final String code;
}

/// 신고 사유 시트에 노출할 표시 라벨.
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
