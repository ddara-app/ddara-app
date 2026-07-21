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
    @Default(0) int commentCount,
    // 최신 댓글 미리보기. 없으면 빈 목록.
    @Default(<FeedComment>[]) List<FeedComment> latestComments,
    required DateTime uploadedAt,
  }) = _FeedItem;
}

/// 피드 항목에 딸린 최신 댓글 미리보기.
///
/// 댓글 시트의 [Comment] 와 달리 commentId·작성 시각 없이
/// 미리보기에 필요한 최소 정보만 담는다.
@freezed
abstract class FeedComment with _$FeedComment {
  const factory FeedComment({
    required int userId,
    required String nickname,
    // 작성자 프로필 이미지 URL. 미등록이면 null. (기본 아바타 표시)
    String? profileImageUrl,
    // 댓글 내용. 신고 접수로 검토 중(underReview)이면 null.
    required String? content,
    @Default(false) bool underReview,
  }) = _FeedComment;
}