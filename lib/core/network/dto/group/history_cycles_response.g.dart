// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_cycles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryCyclesResponse _$HistoryCyclesResponseFromJson(
  Map<String, dynamic> json,
) => _HistoryCyclesResponse(
  stats: json['stats'] == null
      ? null
      : HistoryStatsResponse.fromJson(json['stats'] as Map<String, dynamic>),
  cycles: (json['cycles'] as List<dynamic>)
      .map((e) => HistoryCycleResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HistoryCyclesResponseToJson(
  _HistoryCyclesResponse instance,
) => <String, dynamic>{'stats': instance.stats, 'cycles': instance.cycles};

_HistoryStatsResponse _$HistoryStatsResponseFromJson(
  Map<String, dynamic> json,
) => _HistoryStatsResponse(
  myCount: (json['myCount'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
);

Map<String, dynamic> _$HistoryStatsResponseToJson(
  _HistoryStatsResponse instance,
) => <String, dynamic>{
  'myCount': instance.myCount,
  'totalCount': instance.totalCount,
};

_HistoryCycleResponse _$HistoryCycleResponseFromJson(
  Map<String, dynamic> json,
) => _HistoryCycleResponse(
  cycleId: (json['cycleId'] as num).toInt(),
  topic: json['topic'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  thumbnailUnderReview: json['thumbnailUnderReview'] as bool,
  starterUserId: (json['starterUserId'] as num).toInt(),
  participantCount: (json['participantCount'] as num).toInt(),
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map(
            (e) =>
                HistoryParticipantResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <HistoryParticipantResponse>[],
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$HistoryCycleResponseToJson(
  _HistoryCycleResponse instance,
) => <String, dynamic>{
  'cycleId': instance.cycleId,
  'topic': instance.topic,
  'thumbnailUrl': instance.thumbnailUrl,
  'thumbnailUnderReview': instance.thumbnailUnderReview,
  'starterUserId': instance.starterUserId,
  'participantCount': instance.participantCount,
  'participants': instance.participants,
  'date': instance.date.toIso8601String(),
};

_HistoryParticipantResponse _$HistoryParticipantResponseFromJson(
  Map<String, dynamic> json,
) => _HistoryParticipantResponse(
  userId: (json['userId'] as num).toInt(),
  profileImageUrl: json['profileImageUrl'] as String?,
);

Map<String, dynamic> _$HistoryParticipantResponseToJson(
  _HistoryParticipantResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'profileImageUrl': instance.profileImageUrl,
};
