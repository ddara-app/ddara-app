import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_cycles_response.freezed.dart';
part 'history_cycles_response.g.dart';

@freezed
abstract class HistoryCyclesResponse with _$HistoryCyclesResponse {
  const factory HistoryCyclesResponse({
    // 지난 따라찍기 통계. (더보기 화면 전용, 모임 페이지 프리뷰는 사용 안 함)
    // 서버 미제공 시 null.
    HistoryStatsResponse? stats,
    required List<HistoryCycleResponse> cycles,
  }) = _HistoryCyclesResponse;

  factory HistoryCyclesResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryCyclesResponseFromJson(json);
}

@freezed
abstract class HistoryStatsResponse with _$HistoryStatsResponse {
  const factory HistoryStatsResponse({
    // 내가 참여한 따라찍기 수.
    required int myCount,
    // 모임의 전체 따라찍기 수.
    required int totalCount,
  }) = _HistoryStatsResponse;

  factory HistoryStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryStatsResponseFromJson(json);
}

@freezed
abstract class HistoryCycleResponse with _$HistoryCycleResponse {
  const factory HistoryCycleResponse({
    required int cycleId,
    required String topic,
    // 대표 썸네일. 없으면 null.
    required String? thumbnailUrl,
    // 썸네일이 신고 접수로 검토 중인지 여부.
    required bool thumbnailUnderReview,
    // 썸네일(스타터 샷)을 올린 스타터의 userId.
    required int starterUserId,
    required int participantCount,
    // 참가자 목록. (더보기 화면의 참가자 아바타 전용) 서버 미제공 시 빈 목록.
    @Default(<HistoryParticipantResponse>[])
    List<HistoryParticipantResponse> participants,
    required DateTime date,
  }) = _HistoryCycleResponse;

  factory HistoryCycleResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryCycleResponseFromJson(json);
}

@freezed
abstract class HistoryParticipantResponse with _$HistoryParticipantResponse {
  const factory HistoryParticipantResponse({
    required int userId,
    // 참가자 프로필 이미지 URL. 없으면 null.
    required String? profileImageUrl,
  }) = _HistoryParticipantResponse;

  factory HistoryParticipantResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryParticipantResponseFromJson(json);
}
