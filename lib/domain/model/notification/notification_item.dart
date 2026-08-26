import 'package:ddara/domain/model/notification/notification_payload.dart';
import 'package:ddara/domain/model/notification/notification_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.freezed.dart';

@freezed
abstract class NotificationItem with _$NotificationItem {
  const NotificationItem._();

  const factory NotificationItem({
    required int id,
    required NotificationType type,
    required NotificationPayload payload,
    // 아직 읽지 않은 경우 null.
    required DateTime? readAt,
    required DateTime createdAt,
  }) = _NotificationItem;

  /// 읽음 여부.
  bool get isRead => readAt != null;
}
