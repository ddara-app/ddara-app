import 'package:ddara/core/model/notification/notification_item.dart';
import 'package:ddara/core/model/notification/notification_list.dart';
import 'package:ddara/core/model/notification/notification_payload.dart';
import 'package:ddara/core/model/notification/notification_type.dart';
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
      // 종류마다 다른 payload 를 평탄한 도메인 모델로 펼친다. (없는 필드는 null)
      payload: NotificationPayload(
        groupId: payload['groupId'] as int?,
        groupName: payload['groupName'] as String?,
        actorNickname: payload['actorNickname'] as String?,
        cycleId: payload['cycleId'] as int?,
        imageUrl: payload['imageUrl'] as String?,
      ),
      readAt: readAt,
      createdAt: createdAt,
    );
  }
}
