import 'package:ddara/core/model/notification/notification_item.dart';
import 'package:ddara/core/model/notification/notification_type.dart';
import 'package:ddara/l10n/app_localizations.dart';

/// 도메인 알림 모델에서 화면 표시용 문자열을 뽑아내는 확장.
///
/// 문자열은 전부 l10n 에서 가져오므로, 위젯이 [AppLocalizations] 를 넘겨 호출한다.
extension NotificationDisplay on NotificationItem {
  /// 썸네일을 박스(배경·라운드) 없이 이미지 그대로 보여줄지 여부.
  ///
  /// MEMBER_JOIN·DEADLINE 은 payload 이미지가 앱 로고라, 사진용 박스 없이
  /// 로고만 그대로 노출한다.
  bool get showsBareThumbnail =>
      type == NotificationType.memberJoin || type == NotificationType.deadline;

  /// 알림 분류 라벨. (예: '모임 합류')
  String displayLabel(AppLocalizations l10n) {
    switch (type) {
      case NotificationType.memberJoin:
        return l10n.notificationLabelMemberJoin;
      case NotificationType.newCycle:
        return l10n.notificationLabelNewCycle;
      case NotificationType.cycleCompleted:
        return l10n.notificationLabelCycleCompleted;
      case NotificationType.deadline:
        return l10n.notificationLabelDeadline;
      case NotificationType.unknown:
        return l10n.notificationLabelDefault;
    }
  }

  /// 알림 종류·payload 로 만든 본문 문구.
  String displayMessage(AppLocalizations l10n) {
    final groupName = payload.groupName ?? '';
    switch (type) {
      case NotificationType.memberJoin:
        final actor = payload.actorNickname ?? '';
        return l10n.notificationMessageMemberJoin(actor, groupName);
      case NotificationType.newCycle:
        return l10n.notificationMessageNewCycle(groupName);
      case NotificationType.cycleCompleted:
        return l10n.notificationMessageCycleCompleted(groupName);
      case NotificationType.deadline:
        final remaining = deadlineRemainingText(l10n);
        if (remaining != null) {
          return l10n.notificationMessageDeadlineRemaining(
            groupName,
            remaining,
          );
        }
        return l10n.notificationMessageDeadline(groupName);
      case NotificationType.unknown:
        return l10n.notificationMessageDefault;
    }
  }

  /// 마감 임박 알림에서 '생성 시점 기준 마감까지 남은 시간' 문구. (예: '30분', '2시간')
  ///
  /// deadlineAt·createdAt 의 차이로 계산한다. 마감 임박 알림이 아니거나,
  /// deadlineAt 이 없거나, 이미 마감이 지난 경우 null.
  String? deadlineRemainingText(AppLocalizations l10n) {
    if (type != NotificationType.deadline) return null;
    final deadlineAt = payload.deadlineAt;
    if (deadlineAt == null) return null;

    final remaining = deadlineAt.difference(createdAt);
    if (remaining.inMinutes < 1) return null;
    if (remaining.inMinutes < 60) {
      return l10n.remainingMinutes(remaining.inMinutes);
    }
    if (remaining.inHours < 24) return l10n.remainingHours(remaining.inHours);
    return l10n.remainingDays(remaining.inDays);
  }

  /// 생성 시각을 '방금 전'·'5분 전' 같은 상대 시간 문자열로 변환한다.
  String displayTimeAgo(AppLocalizations l10n) {
    final diff = DateTime.now().difference(createdAt);

    if (diff.inMinutes < 1) return l10n.timeAgoJustNow;
    if (diff.inMinutes < 60) return l10n.timeAgoMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeAgoHours(diff.inHours);
    if (diff.inDays < 7) return l10n.timeAgoDays(diff.inDays);
    if (diff.inDays < 30) return l10n.timeAgoWeeks(diff.inDays ~/ 7);
    if (diff.inDays < 365) return l10n.timeAgoMonths(diff.inDays ~/ 30);
    return l10n.timeAgoYears(diff.inDays ~/ 365);
  }
}
