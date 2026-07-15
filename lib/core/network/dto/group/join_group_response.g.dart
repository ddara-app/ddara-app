// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JoinGroupResponse _$JoinGroupResponseFromJson(Map<String, dynamic> json) =>
    _JoinGroupResponse(
      groupId: (json['groupId'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$JoinGroupResponseToJson(_JoinGroupResponse instance) =>
    <String, dynamic>{'groupId': instance.groupId, 'name': instance.name};
