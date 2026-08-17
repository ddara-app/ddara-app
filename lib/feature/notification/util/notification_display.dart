import 'package:ddara/domain/model/notification/notification_item.dart';
import 'package:ddara/domain/model/notification/notification_type.dart';
import 'package:ddara/core/util/time_ago.dart';
import 'package:ddara/l10n/app_localizations.dart';

/// 도메인 알림 모델에서 화면 표시용 문자열을 뽑아내는 확장.
///
/// 문자열은 전부 l10n 에서 가져오므로, 위젯이 [AppLocalizations] 를 넘겨 호출한다.
extension NotificationDisplay on NotificationItem {
  /// 알림 분류 라벨. (예: '따라찍기 알림')
  ///
  /// 알림 설정 화면의 항목명을 그대로 쓴다 — 설정에서 끈 항목과 목록에 뜬
  /// 알림이 같은 이름으로 보여야 어떤 토글이 이 알림을 막는지 알 수 있다.
  /// 그래서 한 항목이 여러 타입을 덮는 경우(따라찍기 알림 = 시작·종료·마감)
  /// 라벨도 하나로 묶인다.
  String displayLabel(AppLocalizations l10n) {
    switch (type) {
      case NotificationType.newCycle:
      case NotificationType.cycleCompleted:
      case NotificationType.deadline:
        return l10n.notificationFollowShot;
      case NotificationType.friendShot:
        return l10n.notificationFriendShot;
      case NotificationType.starterAssigned:
        return l10n.notificationStarterAssigned;
      case NotificationType.comment:
        return l10n.notificationComment;
      case NotificationType.memberJoin:
        return l10n.notificationMemberJoin;
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
        // 스타터 닉네임이 오지 않는 경우가 있어(payload 에 actorNickname 이
        // 없는 계약) 이름 없는 문구로 대체한다.
        final starter = payload.actorNickname;
        if (starter == null || starter.isEmpty) {
          return l10n.notificationMessageNewCycleNoActor(groupName);
        }
        return l10n.notificationMessageNewCycle(groupName, starter);
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
      case NotificationType.starterAssigned:
        return l10n.notificationMessageStarterAssigned(groupName);
      case NotificationType.friendShot:
        return l10n.notificationMessageFriendShot(
          groupName,
          payload.actorNickname ?? '',
        );
      case NotificationType.comment:
        final actor = payload.actorNickname ?? '';
        // 남의 사진에 달린 댓글도 알림으로 오므로 사진 주인을 밝혀 준다.
        // (주인 닉네임을 모르면 '내 사진' 으로 단정하지 않게 기본 문구로 둔다)
        final owner = payload.shotOwnerNickname;
        if (!payload.isMyShot && owner != null && owner.isNotEmpty) {
          // 작성자와 사진 주인이 같으면 같은 이름을 두 번 부르지 않고
          // '본인 사진' 으로 줄인다. 한 모임 안에서 닉네임은 중복될 수 없어
          // (닉네임 변경 시트가 막는다) 이름으로 견줘도 안전하다.
          if (owner == actor) {
            return l10n.notificationMessageCommentOnOwn(groupName, actor);
          }
          return l10n.notificationMessageCommentOnOthers(
            groupName,
            actor,
            owner,
          );
        }
        return l10n.notificationMessageComment(groupName, actor);
      case NotificationType.unknown:
        return l10n.notificationMessageDefault;
    }
  }

  /// 마감 임박 알림에서 '생성 시점 기준 마감까지 남은 시간' 문구. (예: '30분', '2시간')
  ///
  /// 서버가 내려준 remainingMinutes 를 우선 사용하고, 없으면
  /// deadlineAt·createdAt 의 차이로 계산한다. 마감 임박 알림이 아니거나,
  /// 남은 시간을 알 수 없거나, 이미 마감이 지난 경우 null.
  String? deadlineRemainingText(AppLocalizations l10n) {
    if (type != NotificationType.deadline) return null;

    final minutes = payload.remainingMinutes ?? _computedRemainingMinutes;
    if (minutes == null || minutes < 1) return null;
    if (minutes < 60) return l10n.remainingMinutes(minutes);
    if (minutes < Duration.minutesPerDay) {
      return l10n.remainingHours(minutes ~/ Duration.minutesPerHour);
    }
    return l10n.remainingDays(minutes ~/ Duration.minutesPerDay);
  }

  /// deadlineAt 이 있을 때 생성 시점 기준 남은 분. (remainingMinutes 폴백용)
  int? get _computedRemainingMinutes {
    final deadlineAt = payload.deadlineAt;
    if (deadlineAt == null) return null;
    return deadlineAt.difference(createdAt).inMinutes;
  }

  /// 생성 시각을 '방금 전'·'5분 전' 같은 상대 시간 문자열로 변환한다.
  String displayTimeAgo(AppLocalizations l10n) => timeAgoLabel(createdAt, l10n);
}
