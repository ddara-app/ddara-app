import 'package:ddara/domain/model/notification/notification_item.dart';
import 'package:ddara/domain/model/notification/notification_payload.dart';
import 'package:ddara/domain/model/notification/notification_type.dart';
import 'package:ddara/feature/notification/util/notification_display.dart';
import 'package:ddara/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

NotificationItem _item({
  required NotificationType type,
  NotificationPayload? payload,
  DateTime? createdAt,
}) {
  return NotificationItem(
    id: 1,
    type: type,
    payload: payload ??
        const NotificationPayload(
          groupId: 1,
          groupName: '모임',
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
    createdAt: createdAt ?? DateTime.now(),
  );
}

void main() {
  final l10n = lookupAppLocalizations(const Locale('ko'));

  group('displayLabel', () {
    test('newCycle·cycleCompleted·deadline 은 같은 라벨(따라찍기 알림)로 묶인다', () {
      expect(
        _item(type: NotificationType.newCycle).displayLabel(l10n),
        l10n.notificationFollowShot,
      );
      expect(
        _item(type: NotificationType.cycleCompleted).displayLabel(l10n),
        l10n.notificationFollowShot,
      );
      expect(
        _item(type: NotificationType.deadline).displayLabel(l10n),
        l10n.notificationFollowShot,
      );
    });

    test('unknown 은 기본 라벨을 쓴다', () {
      expect(
        _item(type: NotificationType.unknown).displayLabel(l10n),
        l10n.notificationLabelDefault,
      );
    });
  });

  group('displayMessage', () {
    test('newCycle 에 스타터 닉네임이 없으면 이름 없는 문구로 대체한다', () {
      final item = _item(
        type: NotificationType.newCycle,
        payload: const NotificationPayload(
          groupId: 1,
          groupName: '모임',
          actorNickname: null,
          cycleId: 1,
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
      );

      expect(item.displayMessage(l10n), l10n.notificationMessageNewCycleNoActor('모임'));
    });

    test('comment 는 사진 주인이 작성자 본인이면 본인 사진 문구를 쓴다', () {
      final item = _item(
        type: NotificationType.comment,
        payload: const NotificationPayload(
          groupId: 1,
          groupName: '모임',
          actorNickname: '작성자',
          cycleId: 1,
          shotId: 1,
          deadlineAt: null,
          remainingMinutes: null,
          imageUrl: null,
          imageUnderReview: false,
          locked: false,
          starterUserId: null,
          shotOwnerUserId: 1,
          shotOwnerNickname: '작성자',
          isMyShot: false,
        ),
      );

      expect(
        item.displayMessage(l10n),
        l10n.notificationMessageCommentOnOwn('모임', '작성자'),
      );
    });

    test('comment 가 내 사진(isMyShot)이면 사진 주인 문구를 쓰지 않는다', () {
      final item = _item(
        type: NotificationType.comment,
        payload: const NotificationPayload(
          groupId: 1,
          groupName: '모임',
          actorNickname: '작성자',
          cycleId: 1,
          shotId: 1,
          deadlineAt: null,
          remainingMinutes: null,
          imageUrl: null,
          imageUnderReview: false,
          locked: false,
          starterUserId: null,
          shotOwnerUserId: 100,
          shotOwnerNickname: '나',
          isMyShot: true,
        ),
      );

      expect(item.displayMessage(l10n), l10n.notificationMessageComment('모임', '작성자'));
    });

    test('unknown 은 기본 문구를 쓴다', () {
      expect(
        _item(type: NotificationType.unknown).displayMessage(l10n),
        l10n.notificationMessageDefault,
      );
    });
  });

  group('deadlineRemainingText', () {
    test('deadline 이 아니면 null 이다', () {
      final item = _item(type: NotificationType.comment);

      expect(item.deadlineRemainingText(l10n), isNull);
    });

    test('remainingMinutes 가 60 미만이면 분 단위로 표시한다', () {
      final item = _item(
        type: NotificationType.deadline,
        payload: const NotificationPayload(
          groupId: 1,
          groupName: '모임',
          actorNickname: null,
          cycleId: 1,
          shotId: null,
          deadlineAt: null,
          remainingMinutes: 30,
          imageUrl: null,
          imageUnderReview: false,
          locked: false,
          starterUserId: null,
          shotOwnerUserId: null,
          shotOwnerNickname: null,
          isMyShot: false,
        ),
      );

      expect(item.deadlineRemainingText(l10n), l10n.remainingMinutes(30));
    });

    test('remainingMinutes 가 없으면 deadlineAt·createdAt 차이로 계산한다', () {
      final createdAt = DateTime(2026, 1, 1, 0, 0);
      final item = _item(
        type: NotificationType.deadline,
        createdAt: createdAt,
        payload: NotificationPayload(
          groupId: 1,
          groupName: '모임',
          actorNickname: null,
          cycleId: 1,
          shotId: null,
          deadlineAt: createdAt.add(const Duration(hours: 2)),
          remainingMinutes: null,
          imageUrl: null,
          imageUnderReview: false,
          locked: false,
          starterUserId: null,
          shotOwnerUserId: null,
          shotOwnerNickname: null,
          isMyShot: false,
        ),
      );

      expect(item.deadlineRemainingText(l10n), l10n.remainingHours(2));
    });

    test('마감이 이미 지났으면(0분 미만) null 이다', () {
      final createdAt = DateTime(2026, 1, 1, 2, 0);
      final item = _item(
        type: NotificationType.deadline,
        createdAt: createdAt,
        payload: NotificationPayload(
          groupId: 1,
          groupName: '모임',
          actorNickname: null,
          cycleId: 1,
          shotId: null,
          deadlineAt: createdAt.subtract(const Duration(minutes: 1)),
          remainingMinutes: null,
          imageUrl: null,
          imageUnderReview: false,
          locked: false,
          starterUserId: null,
          shotOwnerUserId: null,
          shotOwnerNickname: null,
          isMyShot: false,
        ),
      );

      expect(item.deadlineRemainingText(l10n), isNull);
    });
  });
}
