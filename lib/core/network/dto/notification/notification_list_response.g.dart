// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationListResponse _$NotificationListResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationListResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => NotificationItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  unreadCount: (json['unreadCount'] as num).toInt(),
);

Map<String, dynamic> _$NotificationListResponseToJson(
  _NotificationListResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'unreadCount': instance.unreadCount,
};

_NotificationItemResponse _$NotificationItemResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationItemResponse(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  payload: json['payload'] as Map<String, dynamic>,
  readAt: json['readAt'] == null
      ? null
      : DateTime.parse(json['readAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$NotificationItemResponseToJson(
  _NotificationItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'payload': instance.payload,
  'readAt': instance.readAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};
