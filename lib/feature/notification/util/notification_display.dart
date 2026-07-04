import 'package:ddara/core/model/notification/notification_item.dart';
import 'package:ddara/core/model/notification/notification_type.dart';

/// 도메인 알림 모델에서 화면 표시용 문자열을 뽑아내는 확장.
extension NotificationDisplay on NotificationItem {
  /// 알림 분류 라벨. (예: '모임 합류')
  String get displayLabel {
    switch (type) {
      case NotificationType.memberJoin:
        return '모임 합류';
      case NotificationType.newCycle:
        return '따라찍기 시작';
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
      case NotificationType.unknown:
        return '새로운 알림이 있어요';
    }
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
