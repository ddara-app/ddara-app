import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_cycles_response.freezed.dart';
part 'history_cycles_response.g.dart';

@freezed
abstract class HistoryCyclesResponse with _$HistoryCyclesResponse {
  const factory HistoryCyclesResponse({
    required List<HistoryCycleResponse> cycles,
  }) = _HistoryCyclesResponse;

  factory HistoryCyclesResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryCyclesResponseFromJson(json);
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
    required DateTime date,
  }) = _HistoryCycleResponse;

  factory HistoryCycleResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryCycleResponseFromJson(json);
}
