import 'package:ddara/l10n/app_localizations.dart';

/// 신고 사유. (`POST /api/reports` 의 reasonCode 와 1:1 매핑)
enum ReportReason {
  /// 음란물.
  obscene('OBSCENE'),

  /// 폭력·혐오.
  violence('VIOLENCE'),

  /// 타인 무단촬영.
  unauthorizedPhoto('UNAUTHORIZED_PHOTO'),

  /// 사칭·괴롭힘.
  harassment('HARASSMENT'),

  /// 기타. (신고 시 상세 내용(reasonText)이 필수)
  etc('ETC');

  const ReportReason(this.code);

  /// 서버로 보내는 reasonCode 문자열.
  final String code;
}

/// 신고 사유 시트에 노출할 표시 라벨. (사진 신고 문구)
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
