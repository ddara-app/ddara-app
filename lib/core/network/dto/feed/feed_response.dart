import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_response.freezed.dart';
part 'feed_response.g.dart';

/// `GET /api/feed` 응답 DTO. (홈 최근 업데이트 탭)
@freezed
abstract class FeedResponse with _$FeedResponse {
  const factory FeedResponse({
    // 대시보드에 노출할 업데이트 개수.
    @Default(0) int updateCount,
    @Default(<FeedItemResponse>[]) List<FeedItemResponse> items,
  }) = _FeedResponse;

  factory FeedResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseFromJson(json);
}

/// 최근 업데이트 항목 하나. (사진 한 장 + 그 사진이 속한 모임·회차 정보)
@freezed
abstract class FeedItemResponse with _$FeedItemResponse {
  const factory FeedItemResponse({
    required int shotId,
    // 사진 종류. 'starter'(회차를 연 사진) 또는 'member'(따라찍은 사진).
    required String type,
    // 사진 URL. 신고 접수로 검토 중이면 null 로 올 수 있다.
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
  }) = _FeedItemResponse;

  factory FeedItemResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedItemResponseFromJson(json);
}
