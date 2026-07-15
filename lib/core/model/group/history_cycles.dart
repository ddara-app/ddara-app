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
    required int participantCount,
    required DateTime date,
  }) = _HistoryCycle;
}
