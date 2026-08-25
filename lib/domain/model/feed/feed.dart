import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed.freezed.dart';

/// 홈 최근 업데이트 탭에 보여줄 피드. (업데이트 개수 + 항목 목록)
@freezed
abstract class Feed with _$Feed {
  const factory Feed({
    // 대시보드에 노출할 업데이트 개수.
    @Default(0) int updateCount,
    @Default(<FeedItem>[]) List<FeedItem> items,
  }) = _Feed;
}

/// 최근 업데이트 항목 하나. (사진 한 장 + 그 사진이 속한 모임·회차 정보)
@freezed
abstract class FeedItem with _$FeedItem {
  const factory FeedItem({
    required int shotId,
    // 회차를 연 스타터의 사진인지 여부. (아니면 따라찍은 멤버의 사진)
    required bool isStarter,
    // 사진 URL. 신고 접수로 검토 중이면 null.
    required String? imageUrl,
    // 사진이 신고 접수로 검토 중인지 여부.
    @Default(false) bool imageUnderReview,
    // 사진을 올린 사용자.
    required int userId,
    required String nickname,
    // 사진이 속한 모임.
    required int groupId,
    required String groupName,
    // 사진이 속한 회차와 그 주제.
    required int cycleId,
    required String topic,
    // 잠금 여부. 해당 회차에 내 인증샷을 올리지 않았으면 true.
    @Default(false) bool locked,
    required DateTime uploadedAt,
  }) = _FeedItem;
}
