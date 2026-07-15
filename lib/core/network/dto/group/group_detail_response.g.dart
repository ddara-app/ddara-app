// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupDetailResponse _$GroupDetailResponseFromJson(Map<String, dynamic> json) =>
    _GroupDetailResponse(
      groupId: (json['groupId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      inviteCode: json['inviteCode'] as String,
      ownerUserId: (json['ownerUserId'] as num).toInt(),
      memberCount: (json['memberCount'] as num).toInt(),
      members: (json['members'] as List<dynamic>)
          .map((e) => GroupMemberResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentCycle: json['currentCycle'] == null
          ? null
          : GroupCycleResponse.fromJson(
              json['currentCycle'] as Map<String, dynamic>,
            ),
      canStartCycle: json['canStartCycle'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GroupDetailResponseToJson(
  _GroupDetailResponse instance,
) => <String, dynamic>{
  'groupId': instance.groupId,
  'name': instance.name,
  'description': instance.description,
  'inviteCode': instance.inviteCode,
  'ownerUserId': instance.ownerUserId,
  'memberCount': instance.memberCount,
  'members': instance.members,
  'currentCycle': instance.currentCycle,
  'canStartCycle': instance.canStartCycle,
  'createdAt': instance.createdAt.toIso8601String(),
};

_GroupMemberResponse _$GroupMemberResponseFromJson(Map<String, dynamic> json) =>
    _GroupMemberResponse(
      userId: (json['userId'] as num).toInt(),
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      role: json['role'] as String,
    );

Map<String, dynamic> _$GroupMemberResponseToJson(
  _GroupMemberResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'nickname': instance.nickname,
  'profileImageUrl': instance.profileImageUrl,
  'role': instance.role,
};

_GroupCycleResponse _$GroupCycleResponseFromJson(Map<String, dynamic> json) =>
    _GroupCycleResponse(
      cycleId: (json['cycleId'] as num).toInt(),
      cycleNumber: (json['cycleNumber'] as num).toInt(),
      topic: json['topic'] as String,
      starterUserId: (json['starterUserId'] as num).toInt(),
      starterNickname: json['starterNickname'] as String,
      starterImageUrl: json['starterImageUrl'] as String?,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      deadlineAt: DateTime.parse(json['deadlineAt'] as String),
    );

Map<String, dynamic> _$GroupCycleResponseToJson(_GroupCycleResponse instance) =>
    <String, dynamic>{
      'cycleId': instance.cycleId,
      'cycleNumber': instance.cycleNumber,
      'topic': instance.topic,
      'starterUserId': instance.starterUserId,
      'starterNickname': instance.starterNickname,
      'starterImageUrl': instance.starterImageUrl,
      'status': instance.status,
      'startedAt': instance.startedAt.toIso8601String(),
      'deadlineAt': instance.deadlineAt.toIso8601String(),
    };
