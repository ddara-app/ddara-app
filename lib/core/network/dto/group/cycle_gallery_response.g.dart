// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_gallery_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CycleGalleryResponse _$CycleGalleryResponseFromJson(
  Map<String, dynamic> json,
) => _CycleGalleryResponse(
  groupId: (json['groupId'] as num).toInt(),
  groupName: json['groupName'] as String,
  cycle: CycleGalleryCycleResponse.fromJson(
    json['cycle'] as Map<String, dynamic>,
  ),
  viewerUploaded: json['viewerUploaded'] as bool,
  members: (json['members'] as List<dynamic>)
      .map(
        (e) => CycleGalleryMemberResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$CycleGalleryResponseToJson(
  _CycleGalleryResponse instance,
) => <String, dynamic>{
  'groupId': instance.groupId,
  'groupName': instance.groupName,
  'cycle': instance.cycle,
  'viewerUploaded': instance.viewerUploaded,
  'members': instance.members,
};

_CycleGalleryCycleResponse _$CycleGalleryCycleResponseFromJson(
  Map<String, dynamic> json,
) => _CycleGalleryCycleResponse(
  cycleId: (json['cycleId'] as num).toInt(),
  cycleNumber: (json['cycleNumber'] as num).toInt(),
  topic: json['topic'] as String,
  starterNickname: json['starterNickname'] as String,
  starterImageUrl: json['starterImageUrl'] as String?,
  status: json['status'] as String,
  deadlineAt: DateTime.parse(json['deadlineAt'] as String),
);

Map<String, dynamic> _$CycleGalleryCycleResponseToJson(
  _CycleGalleryCycleResponse instance,
) => <String, dynamic>{
  'cycleId': instance.cycleId,
  'cycleNumber': instance.cycleNumber,
  'topic': instance.topic,
  'starterNickname': instance.starterNickname,
  'starterImageUrl': instance.starterImageUrl,
  'status': instance.status,
  'deadlineAt': instance.deadlineAt.toIso8601String(),
};

_CycleGalleryMemberResponse _$CycleGalleryMemberResponseFromJson(
  Map<String, dynamic> json,
) => _CycleGalleryMemberResponse(
  userId: (json['userId'] as num).toInt(),
  nickname: json['nickname'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  isStarter: json['isStarter'] as bool,
  status: json['status'] as String,
  imageUrl: json['imageUrl'] as String?,
  uploadedAt: json['uploadedAt'] == null
      ? null
      : DateTime.parse(json['uploadedAt'] as String),
);

Map<String, dynamic> _$CycleGalleryMemberResponseToJson(
  _CycleGalleryMemberResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'nickname': instance.nickname,
  'profileImageUrl': instance.profileImageUrl,
  'isStarter': instance.isStarter,
  'status': instance.status,
  'imageUrl': instance.imageUrl,
  'uploadedAt': instance.uploadedAt?.toIso8601String(),
};
