import 'package:ddara/core/network/dto/feed/feed_response.dart';
import 'package:ddara/data/repository/mapper/feed_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

FeedItemResponse _item({String type = 'starter', String? imageUrl = 'https://img'}) {
  return FeedItemResponse(
    shotId: 1,
    type: type,
    imageUrl: imageUrl,
    userId: 2,
    nickname: 'nick',
    groupId: 3,
    groupName: 'group',
    cycleId: 4,
    topic: 'topic',
    uploadedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('FeedItemMapper', () {
    test("type 이 'starter' 이면 isStarter 가 true", () {
      final result = _item(type: 'starter').toDomain();

      expect(result.isStarter, true);
    });

    test("type 이 'starter' 가 아니면(예: 'member') isStarter 가 false", () {
      final result = _item(type: 'member').toDomain();

      expect(result.isStarter, false);
    });

    test('신고 검토 중이라 imageUrl 이 null 이면 그대로 null 로 전달한다', () {
      final result = _item(imageUrl: null).toDomain();

      expect(result.imageUrl, isNull);
    });

    test('최신 댓글 미리보기를 함께 변환한다', () {
      final response = _item().copyWith(
        latestComments: const [
          FeedCommentResponse(
            userId: 1,
            nickname: 'nick',
            content: 'hi',
          ),
        ],
      );

      final result = response.toDomain();

      expect(result.latestComments, hasLength(1));
      expect(result.latestComments.first.nickname, 'nick');
    });
  });

  group('FeedMapper', () {
    test('updateCount 와 items 목록을 함께 변환한다', () {
      final response = FeedResponse(updateCount: 2, items: [_item(), _item()]);

      final result = response.toDomain();

      expect(result.updateCount, 2);
      expect(result.items, hasLength(2));
    });

    test('items 가 비어 있으면 빈 목록을 반환한다', () {
      const response = FeedResponse();

      final result = response.toDomain();

      expect(result.updateCount, 0);
      expect(result.items, isEmpty);
    });
  });
}
