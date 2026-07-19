import 'package:ddara/core/model/feed/feed.dart';
import 'package:ddara/core/network/dto/feed/feed_response.dart';

/// 서버가 내려주는 사진 종류 문자열 중 '회차를 연 사진'을 뜻하는 값.
const String _starterType = 'starter';

extension FeedMapper on FeedResponse {
  Feed toDomain() {
    return Feed(
      updateCount: updateCount,
      items: items.map((item) => item.toDomain()).toList(),
    );
  }
}

extension FeedItemMapper on FeedItemResponse {
  FeedItem toDomain() {
    return FeedItem(
      shotId: shotId,
      // 'starter' 외의 값은 모두 따라찍은 멤버 사진으로 본다.
      isStarter: type == _starterType,
      imageUrl: imageUrl,
      imageUnderReview: imageUnderReview,
      userId: userId,
      nickname: nickname,
      groupId: groupId,
      groupName: groupName,
      cycleId: cycleId,
      topic: topic,
      locked: locked,
      commentCount: commentCount,
      latestComments: latestComments
          .map((comment) => comment.toDomain())
          .toList(),
      uploadedAt: uploadedAt,
    );
  }
}

extension FeedCommentMapper on FeedCommentResponse {
  FeedComment toDomain() {
    return FeedComment(
      userId: userId,
      nickname: nickname,
      content: content,
      underReview: underReview,
    );
  }
}
