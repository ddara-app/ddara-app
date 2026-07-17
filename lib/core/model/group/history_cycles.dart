import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_cycles.freezed.dart';

@freezed
abstract class HistoryCycles with _$HistoryCycles {
  const factory HistoryCycles({required List<HistoryCycle> cycles}) =
      _HistoryCycles;
}

@freezed
abstract class HistoryCycle with _$HistoryCycle {
  const factory HistoryCycle({
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
  }) = _HistoryCycle;
}
