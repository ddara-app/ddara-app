// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InviteGroupResponse _$InviteGroupResponseFromJson(Map<String, dynamic> json) =>
    _InviteGroupResponse(
      groupId: (json['groupId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      ownerNickname: json['ownerNickname'] as String,
      memberCount: (json['memberCount'] as num).toInt(),
      capacity: (json['capacity'] as num).toInt(),
      isFull: json['isFull'] as bool,
      memberAvatars: (json['memberAvatars'] as List<dynamic>)
          .map((e) => e as String?)
          .toList(),
      alreadyJoined: json['alreadyJoined'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$InviteGroupResponseToJson(
  _InviteGroupResponse instance,
) => <String, dynamic>{
  'groupId': instance.groupId,
  'name': instance.name,
  'description': instance.description,
  'ownerNickname': instance.ownerNickname,
  'memberCount': instance.memberCount,
  'capacity': instance.capacity,
  'isFull': instance.isFull,
  'memberAvatars': instance.memberAvatars,
  'alreadyJoined': instance.alreadyJoined,
  'createdAt': instance.createdAt.toIso8601String(),
};
