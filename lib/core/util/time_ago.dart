import 'package:ddara/l10n/app_localizations.dart';

/// [dateTime] 을 현재 기준 상대 시간 문자열('방금 전'·'5분 전'·'2시간 전' 등)로
/// 변환한다. 문자열은 전부 l10n 에서 가져온다.
String timeAgoLabel(DateTime dateTime, AppLocalizations l10n) {
  final diff = DateTime.now().difference(dateTime);

  if (diff.inMinutes < 1) return l10n.timeAgoJustNow;
  if (diff.inMinutes < 60) return l10n.timeAgoMinutes(diff.inMinutes);
  if (diff.inHours < 24) return l10n.timeAgoHours(diff.inHours);
  if (diff.inDays < 7) return l10n.timeAgoDays(diff.inDays);
  if (diff.inDays < 30) return l10n.timeAgoWeeks(diff.inDays ~/ 7);
  if (diff.inDays < 365) return l10n.timeAgoMonths(diff.inDays ~/ 30);
  return l10n.timeAgoYears(diff.inDays ~/ 365);
}
