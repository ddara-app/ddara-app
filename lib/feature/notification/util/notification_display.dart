import 'package:ddara/core/model/notification/notification_item.dart';
import 'package:ddara/core/model/notification/notification_type.dart';

/// 도메인 알림 모델에서 화면 표시용 문자열을 뽑아내는 확장.
extension NotificationDisplay on NotificationItem {
  /// 썸네일을 박스(배경·라운드) 없이 이미지 그대로 보여줄지 여부.
  ///
  /// MEMBER_JOIN·DEADLINE 은 payload 이미지가 앱 로고라, 사진용 박스 없이
  /// 로고만 그대로 노출한다.
  bool get showsBareThumbnail =>
      type == NotificationType.memberJoin ||
      type == NotificationType.deadline;

  /// 알림 분류 라벨. (예: '모임 합류')
  String get displayLabel {
    switch (type) {
      case NotificationType.memberJoin:
        return '모임 합류';
      case NotificationType.newCycle:
        return '따라찍기 시작';
      case NotificationType.cycleCompleted:
        return '따라찍기 종료';
      case NotificationType.deadline:
        return '마감 임박';
      case NotificationType.unknown:
        return '알림';
    }
  }

  /// 알림 종류·payload 로 만든 본문 문구.
  String get displayMessage {
    final groupName = payload.groupName ?? '';
    switch (type) {
      case NotificationType.memberJoin:
        final actor = payload.actorNickname ?? '';
        return '$actor님이 ‘$groupName’ 모임에 합류했어요';
      case NotificationType.newCycle:
        return '‘$groupName’ 모임에서 새로운 따라찍기가 시작됐어요';
      case NotificationType.cycleCompleted:
        return '‘$groupName’ 모임의 따라찍기가 종료됐어요!';
      case NotificationType.deadline:
        final remaining = deadlineRemainingText;
        if (remaining != null) {
          return '‘$groupName’ 모임의 따라찍기 마감까지 $remaining 남았어요. 아직 안찍었죠?';
        }
        return '‘$groupName’ 모임의 따라찍기 마감이 다가와요. 아직 안찍었죠?';
      case NotificationType.unknown:
        return '새로운 알림이 있어요';
    }
  }

  /// 마감 임박 알림에서 '생성 시점 기준 마감까지 남은 시간' 문구. (예: '30분', '2시간')
  ///
  /// deadlineAt·createdAt 의 차이로 계산한다. 마감 임박 알림이 아니거나,
  /// deadlineAt 이 없거나, 이미 마감이 지난 경우 null.
  String? get deadlineRemainingText {
    if (type != NotificationType.deadline) return null;
    final deadlineAt = payload.deadlineAt;
    if (deadlineAt == null) return null;

    final remaining = deadlineAt.difference(createdAt);
    if (remaining.inMinutes < 1) return null;
    if (remaining.inMinutes < 60) return '${remaining.inMinutes}분';
    if (remaining.inHours < 24) return '${remaining.inHours}시간';
    return '${remaining.inDays}일';
  }

  /// 생성 시각을 '방금 전'·'5분 전' 같은 상대 시간 문자열로 변환한다.
  String get displayTimeAgo {
    final diff = DateTime.now().difference(createdAt);

    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7}주 전';
    if (diff.inDays < 365) return '${diff.inDays ~/ 30}개월 전';
    return '${diff.inDays ~/ 365}년 전';
  }
}
