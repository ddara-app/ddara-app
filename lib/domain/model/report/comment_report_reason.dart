import 'package:ddara/l10n/app_localizations.dart';

/// 댓글 신고 사유. (`POST /api/reports` 의 reasonCode 와 매핑)
///
/// 순서가 곧 시트 노출 순서다. 서버 코드는 6종(ABUSE·SEXUAL·HATE·
/// IMPERSONATION·PRIVACY·ETC)이지만, 시트는 5종만 노출하고 PRIVACY 는 쓰지 않는다.
enum CommentReportReason {
  /// 성적 발언.
  sexual('SEXUAL'),

  /// 폭력·혐오 표현.
  violence('HATE'),

  /// 욕설·비방 표현.
  abuse('ABUSE'),

  /// 사칭·괴롭힘.
  harassment('IMPERSONATION'),

  /// 기타. (신고 시 상세 내용(reasonText)이 필수)
  etc('ETC');

  const CommentReportReason(this.code);

  /// 서버로 보내는 reasonCode 문자열.
  final String code;
}

/// 신고 사유 시트에 노출할 표시 라벨.
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
