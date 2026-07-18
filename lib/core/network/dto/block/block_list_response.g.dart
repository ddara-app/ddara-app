// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockListResponse _$BlockListResponseFromJson(Map<String, dynamic> json) =>
    _BlockListResponse(
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => BlockedUserResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockListResponseToJson(_BlockListResponse instance) =>
    <String, dynamic>{'blocks': instance.blocks};

_BlockedUserResponse _$BlockedUserResponseFromJson(Map<String, dynamic> json) =>
    _BlockedUserResponse(
      userId: (json['userId'] as num).toInt(),
      name: json['name'] as String,
      blockedAt: DateTime.parse(json['blockedAt'] as String),
    );

Map<String, dynamic> _$BlockedUserResponseToJson(
  _BlockedUserResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'name': instance.name,
  'blockedAt': instance.blockedAt.toIso8601String(),
};
