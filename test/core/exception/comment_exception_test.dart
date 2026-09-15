import 'package:ddara/core/exception/comment_exception.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CommentException.fromCode', () {
    test('INVALID_INPUT → InvalidCommentInputException', () {
      expect(
        CommentException.fromCode('INVALID_INPUT'),
        isA<InvalidCommentInputException>(),
      );
    });

    test('NOT_GROUP_MEMBER → NotGroupMemberException (group_exception 공용)', () {
      expect(
        CommentException.fromCode('NOT_GROUP_MEMBER'),
        isA<NotGroupMemberException>(),
      );
    });

    test('SHOT_LOCKED → ShotLockedException', () {
      expect(CommentException.fromCode('SHOT_LOCKED'), isA<ShotLockedException>());
    });

    test('SHOT_NOT_FOUND → ShotNotFoundException (report_exception 공용)', () {
      expect(
        CommentException.fromCode('SHOT_NOT_FOUND'),
        isA<ShotNotFoundException>(),
      );
    });

    test('SHOT_UNDER_REVIEW → ShotUnderReviewException', () {
      expect(
        CommentException.fromCode('SHOT_UNDER_REVIEW'),
        isA<ShotUnderReviewException>(),
      );
    });

    test('COMMENT_FORBIDDEN → CommentForbiddenException', () {
      expect(
        CommentException.fromCode('COMMENT_FORBIDDEN'),
        isA<CommentForbiddenException>(),
      );
    });

    test('COMMENT_NOT_FOUND → CommentNotFoundException', () {
      expect(
        CommentException.fromCode('COMMENT_NOT_FOUND'),
        isA<CommentNotFoundException>(),
      );
    });

    test('매칭되지 않는 code 는 null', () {
      expect(CommentException.fromCode('UNKNOWN_CODE'), isNull);
    });

    test('code 가 null 이어도 null', () {
      expect(CommentException.fromCode(null), isNull);
    });
  });
}
