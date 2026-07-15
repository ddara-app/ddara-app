// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_nickname_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangeNickNameResponse _$ChangeNickNameResponseFromJson(
  Map<String, dynamic> json,
) => _ChangeNickNameResponse(
  groupId: (json['groupId'] as num).toInt(),
  nickname: json['nickname'] as String,
);

Map<String, dynamic> _$ChangeNickNameResponseToJson(
  _ChangeNickNameResponse instance,
) => <String, dynamic>{
  'groupId': instance.groupId,
  'nickname': instance.nickname,
};
