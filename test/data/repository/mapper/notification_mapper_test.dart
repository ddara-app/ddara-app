import 'package:ddara/core/network/dto/notification/notification_list_response.dart';
import 'package:ddara/data/repository/mapper/notification_mapper.dart';
import 'package:ddara/domain/model/notification/notification_type.dart';
import 'package:flutter_test/flutter_test.dart';

NotificationItemResponse _item({
  String type = 'MEMBER_JOIN',
  NotificationPayloadResponse? payload,
}) {
  return NotificationItemResponse(
    id: 1,
    type: type,
    payload: payload ??
        const NotificationPayloadResponse(
          groupId: 1,
          groupName: 'group',
          actorNickname: 'nick',
          cycleId: null,
          imageUrl: null,
        ),
    readAt: null,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('NotificationItemMapper', () {
    test("서버 type 문자열을 알려진 NotificationType 으로 매핑한다", () {
      final result = _item(type: 'COMMENT').toDomain();

      expect(result.type, NotificationType.comment);
    });

    test('알 수 없는 type 문자열은 unknown 으로 매핑한다', () {
      final result = _item(type: 'SOMETHING_NEW').toDomain();

      expect(result.type, NotificationType.unknown);
    });

    test('imageUnderReview·locked·isMyShot 이 없으면(null) false 로 기본 처리한다', () {
      const payload = NotificationPayloadResponse(
        groupId: null,
        groupName: null,
        actorNickname: null,
        cycleId: 1,
        imageUrl: 'https://img',
      );

      final result = _item(payload: payload).toDomain();

      expect(result.payload.imageUnderReview, false);
      expect(result.payload.locked, false);
      expect(result.payload.isMyShot, false);
    });

    test('명시적으로 내려온 true 값은 그대로 유지한다', () {
      const payload = NotificationPayloadResponse(
        groupId: null,
        groupName: null,
        actorNickname: null,
        cycleId: 1,
        shotId: 2,
        imageUrl: 'https://img',
        imageUnderReview: true,
        locked: true,
        shotOwnerUserId: 3,
        shotOwnerNickname: 'owner',
        isMyShot: true,
      );

      final result = _item(type: 'COMMENT', payload: payload).toDomain();

      expect(result.payload.imageUnderReview, true);
      expect(result.payload.locked, true);
      expect(result.payload.isMyShot, true);
      expect(result.payload.shotOwnerUserId, 3);
      expect(result.payload.shotOwnerNickname, 'owner');
    });

    test('읽지 않은 알림은 readAt 이 null', () {
      final result = _item().toDomain();

      expect(result.readAt, isNull);
    });
  });

  group('NotificationListMapper', () {
    test('목록의 각 알림을 순서대로 변환한다', () {
      final response = NotificationListResponse(
        items: [_item(), _item()],
        unreadCount: 2,
      );

      final result = response.toDomain();

      expect(result.items, hasLength(2));
    });
  });
}
