// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateGroupResponse _$CreateGroupResponseFromJson(Map<String, dynamic> json) =>
    _CreateGroupResponse(
      groupId: (json['groupId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      inviteCode: json['inviteCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CreateGroupResponseToJson(
  _CreateGroupResponse instance,
) => <String, dynamic>{
  'groupId': instance.groupId,
  'name': instance.name,
  'description': instance.description,
  'inviteCode': instance.inviteCode,
  'createdAt': instance.createdAt.toIso8601String(),
};
