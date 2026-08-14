import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_list.freezed.dart';

/// 지난 따라찍기 '더보기' 화면용 모델.
///
/// 모임 페이지 프리뷰([HistoryCycles])와 달리 통계(stats)와 참가자 목록까지
/// 담는다. 같은 응답에서 화면별로 필요한 만큼만 변환한다.
@freezed
abstract class HistoryList with _$HistoryList {
  const factory HistoryList({
    required HistoryStats stats,
    required List<HistoryListCycle> cycles,
  }) = _HistoryList;
}

/// 지난 따라찍기 통계. (기록 요약 카드에 사용)
@freezed
abstract class HistoryStats with _$HistoryStats {
  const factory HistoryStats({
    // 내가 참여한 따라찍기 수.
    required int myCount,
    // 모임의 전체 따라찍기 수.
    required int totalCount,
  }) = _HistoryStats;
}

@freezed
abstract class HistoryListCycle with _$HistoryListCycle {
  const factory HistoryListCycle({
    required int cycleId,
    required String topic,
    // 대표 썸네일. 없으면 null.
    required String? thumbnailUrl,
    // 썸네일이 신고 접수로 검토 중인지 여부.
    required bool thumbnailUnderReview,
    // 썸네일(스타터 샷)을 올린 스타터의 userId.
    required int starterUserId,
    required int participantCount,
    // 참가자 목록. (참가자 아바타 표시에 사용)
    required List<HistoryParticipant> participants,
    required DateTime date,
  }) = _HistoryListCycle;
}

@freezed
abstract class HistoryParticipant with _$HistoryParticipant {
  const factory HistoryParticipant({
    required int userId,
    // 참가자 프로필 이미지 URL. 없으면 null.
    required String? profileImageUrl,
  }) = _HistoryParticipant;
}
