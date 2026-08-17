import 'package:ddara/domain/model/notification/notification_item.dart';
import 'package:ddara/domain/model/notification/notification_list.dart';
import 'package:ddara/domain/model/notification/notification_payload.dart';
import 'package:ddara/domain/model/notification/notification_type.dart';
import 'package:ddara/core/network/dto/notification/notification_list_response.dart';

extension NotificationListMapper on NotificationListResponse {
  NotificationList toDomain() {
    return NotificationList(
      items: items.map((item) => item.toDomain()).toList(),
    );
  }
}

extension NotificationItemMapper on NotificationItemResponse {
  NotificationItem toDomain() {
    return NotificationItem(
      id: id,
      type: NotificationType.fromValue(type),
      // 종류마다 다른 payload 를 도메인 모델로 옮긴다. (없는 필드는 null)
      payload: NotificationPayload(
        groupId: payload.groupId,
        groupName: payload.groupName,
        actorNickname: payload.actorNickname,
        cycleId: payload.cycleId,
        shotId: payload.shotId,
        deadlineAt: payload.deadlineAt,
        remainingMinutes: payload.remainingMinutes,
        imageUrl: payload.imageUrl,
        // 검토·잠금 여부가 없는 알림 종류는 false 로 취급한다.
        imageUnderReview: payload.imageUnderReview ?? false,
        locked: payload.locked ?? false,
        starterUserId: payload.starterUserId,
        shotOwnerUserId: payload.shotOwnerUserId,
        shotOwnerNickname: payload.shotOwnerNickname,
        // 사진 주인 정보가 없는 알림 종류는 '내 사진' 으로 보지 않는다.
        isMyShot: payload.isMyShot ?? false,
      ),
      readAt: readAt,
      createdAt: createdAt,
    );
  }
}
