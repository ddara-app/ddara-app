import 'package:ddara/core/network/dto/comment/comment_response.dart';
import 'package:ddara/data/repository/mapper/comment_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

CommentResponse _comment({
  int commentId = 1,
  bool underReview = false,
  bool reportedByMe = false,
  DateTime? updatedAt,
}) {
  return CommentResponse(
    commentId: commentId,
    userId: 10,
    nickname: 'nick',
    profileImageUrl: 'https://img',
    content: 'hello',
    underReview: underReview,
    reportedByMe: reportedByMe,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: updatedAt,
  );
}

void main() {
  group('CommentMapper', () {
    test('DTO 필드를 그대로 도메인 모델로 옮긴다', () {
      final result = _comment(commentId: 5, updatedAt: DateTime(2026, 1, 2)).toDomain();

      expect(result.commentId, 5);
      expect(result.userId, 10);
      expect(result.nickname, 'nick');
      expect(result.content, 'hello');
      expect(result.updatedAt, DateTime(2026, 1, 2));
    });

    test('POST 응답처럼 updatedAt 이 없으면(null) 그대로 null 로 둔다', () {
      final result = _comment().toDomain();

      expect(result.updatedAt, isNull);
    });

    test('검토 중·신고됨 플래그를 그대로 전달한다', () {
      final result = _comment(underReview: true, reportedByMe: true).toDomain();

      expect(result.underReview, true);
      expect(result.reportedByMe, true);
    });
  });

  group('CommentListMapper', () {
    test('목록의 각 댓글을 순서대로 변환한다', () {
      final response = CommentListResponse(
        comments: [_comment(commentId: 1), _comment(commentId: 2)],
      );

      final result = response.toDomain();

      expect(result.map((c) => c.commentId), [1, 2]);
    });

    test('빈 목록이면 빈 목록을 반환한다', () {
      const response = CommentListResponse(comments: []);

      expect(response.toDomain(), isEmpty);
    });
  });
}
