import 'package:ddara/domain/model/notification/notification_item.dart';
import 'package:ddara/domain/model/notification/notification_payload.dart';
import 'package:ddara/domain/model/notification/notification_type.dart';
import 'package:ddara/feature/notification/util/notification_filter.dart';
import 'package:flutter_test/flutter_test.dart';

NotificationItem _item(NotificationType type) {
  return NotificationItem(
    id: 1,
    type: type,
    payload: const NotificationPayload(
      groupId: null,
      groupName: null,
      actorNickname: null,
      cycleId: null,
      shotId: null,
      deadlineAt: null,
      remainingMinutes: null,
      imageUrl: null,
      imageUnderReview: false,
      locked: false,
      starterUserId: null,
      shotOwnerUserId: null,
      shotOwnerNickname: null,
      isMyShot: false,
    ),
    readAt: null,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  test('all 은 모든 종류의 알림에 매칭된다', () {
    expect(NotificationFilter.all.matches(_item(NotificationType.comment)), true);
    expect(NotificationFilter.all.matches(_item(NotificationType.memberJoin)), true);
  });

  test('comment 는 댓글 알림에만 매칭된다', () {
    expect(NotificationFilter.comment.matches(_item(NotificationType.comment)), true);
    expect(NotificationFilter.comment.matches(_item(NotificationType.memberJoin)), false);
  });

  test('notice 는 댓글을 제외한 알림에 매칭된다', () {
    expect(NotificationFilter.notice.matches(_item(NotificationType.comment)), false);
    expect(NotificationFilter.notice.matches(_item(NotificationType.memberJoin)), true);
  });

  test('notice 는 앱이 모르는 종류(unknown)도 걸러내지 않고 남긴다', () {
    expect(NotificationFilter.notice.matches(_item(NotificationType.unknown)), true);
  });
}
