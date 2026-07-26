// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettingsRequest _$NotificationSettingsRequestFromJson(
  Map<String, dynamic> json,
) => _NotificationSettingsRequest(
  allowAll: json['allowAll'] as bool,
  activity: ActivityNotificationRequest.fromJson(
    json['activity'] as Map<String, dynamic>,
  ),
  etc: EtcNotificationRequest.fromJson(json['etc'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationSettingsRequestToJson(
  _NotificationSettingsRequest instance,
) => <String, dynamic>{
  'allowAll': instance.allowAll,
  'activity': instance.activity,
  'etc': instance.etc,
};

_ActivityNotificationRequest _$ActivityNotificationRequestFromJson(
  Map<String, dynamic> json,
) => _ActivityNotificationRequest(
  followShot: json['followShot'] as bool,
  friendShot: json['friendShot'] as bool,
  starterAssigned: json['starterAssigned'] as bool,
  comment: json['comment'] as bool,
);

Map<String, dynamic> _$ActivityNotificationRequestToJson(
  _ActivityNotificationRequest instance,
) => <String, dynamic>{
  'followShot': instance.followShot,
  'friendShot': instance.friendShot,
  'starterAssigned': instance.starterAssigned,
  'comment': instance.comment,
};

_EtcNotificationRequest _$EtcNotificationRequestFromJson(
  Map<String, dynamic> json,
) => _EtcNotificationRequest(memberJoin: json['memberJoin'] as bool);

Map<String, dynamic> _$EtcNotificationRequestToJson(
  _EtcNotificationRequest instance,
) => <String, dynamic>{'memberJoin': instance.memberJoin};
