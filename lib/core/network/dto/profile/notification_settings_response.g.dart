// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettingsResponse _$NotificationSettingsResponseFromJson(
  Map<String, dynamic> json,
) => _NotificationSettingsResponse(
  allowAll: json['allowAll'] as bool,
  activity: ActivityNotificationResponse.fromJson(
    json['activity'] as Map<String, dynamic>,
  ),
  etc: EtcNotificationResponse.fromJson(json['etc'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationSettingsResponseToJson(
  _NotificationSettingsResponse instance,
) => <String, dynamic>{
  'allowAll': instance.allowAll,
  'activity': instance.activity,
  'etc': instance.etc,
};

_ActivityNotificationResponse _$ActivityNotificationResponseFromJson(
  Map<String, dynamic> json,
) => _ActivityNotificationResponse(
  followShot: json['followShot'] as bool,
  friendShot: json['friendShot'] as bool,
  starterAssigned: json['starterAssigned'] as bool,
);

Map<String, dynamic> _$ActivityNotificationResponseToJson(
  _ActivityNotificationResponse instance,
) => <String, dynamic>{
  'followShot': instance.followShot,
  'friendShot': instance.friendShot,
  'starterAssigned': instance.starterAssigned,
};

_EtcNotificationResponse _$EtcNotificationResponseFromJson(
  Map<String, dynamic> json,
) => _EtcNotificationResponse(memberJoin: json['memberJoin'] as bool);

Map<String, dynamic> _$EtcNotificationResponseToJson(
  _EtcNotificationResponse instance,
) => <String, dynamic>{'memberJoin': instance.memberJoin};
