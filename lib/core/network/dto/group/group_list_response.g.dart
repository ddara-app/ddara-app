// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupListResponse _$GroupListResponseFromJson(Map<String, dynamic> json) =>
    _GroupListResponse(
      groups: (json['groups'] as List<dynamic>)
          .map((e) => GroupResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupListResponseToJson(_GroupListResponse instance) =>
    <String, dynamic>{'groups': instance.groups};

_GroupResponse _$GroupResponseFromJson(Map<String, dynamic> json) =>
    _GroupResponse(
      groupId: (json['groupId'] as num).toInt(),
      name: json['name'] as String,
      ownerNickname: json['ownerNickname'] as String,
      memberCount: (json['memberCount'] as num).toInt(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      currentCycle: json['currentCycle'] == null
          ? null
          : CurrentCycleResponse.fromJson(
              json['currentCycle'] as Map<String, dynamic>,
            ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GroupResponseToJson(_GroupResponse instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'name': instance.name,
      'ownerNickname': instance.ownerNickname,
      'memberCount': instance.memberCount,
      'thumbnailUrl': instance.thumbnailUrl,
      'currentCycle': instance.currentCycle,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_CurrentCycleResponse _$CurrentCycleResponseFromJson(
  Map<String, dynamic> json,
) => _CurrentCycleResponse(
  cycleId: (json['cycleId'] as num).toInt(),
  topic: json['topic'] as String,
  deadlineAt: DateTime.parse(json['deadlineAt'] as String),
);

Map<String, dynamic> _$CurrentCycleResponseToJson(
  _CurrentCycleResponse instance,
) => <String, dynamic>{
  'cycleId': instance.cycleId,
  'topic': instance.topic,
  'deadlineAt': instance.deadlineAt.toIso8601String(),
};
