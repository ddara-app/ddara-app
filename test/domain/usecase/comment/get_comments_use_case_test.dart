import 'package:ddara/domain/model/comment/comment.dart';
import 'package:ddara/domain/repository/comment_repository.dart';
import 'package:ddara/domain/usecase/comment/get_comments_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

Comment _comment({
  required int commentId,
  bool underReview = false,
  bool reportedByMe = false,
}) {
  return Comment(
    commentId: commentId,
    userId: 1,
    nickname: 'nick',
    profileImageUrl: null,
    content: 'hi',
    underReview: underReview,
    reportedByMe: reportedByMe,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  late MockCommentRepository repository;
  late GetCommentsUseCase useCase;

  setUp(() {
    repository = MockCommentRepository();
    useCase = GetCommentsUseCase(repository);
  });

  test('검토 중이거나 내가 신고한 댓글은 목록에서 제외한다', () async {
    when(() => repository.getComments(1)).thenAnswer(
      (_) async => [
        _comment(commentId: 1),
        _comment(commentId: 2, underReview: true),
        _comment(commentId: 3, reportedByMe: true),
      ],
    );

    final result = await useCase.call(1);

    expect(result.map((c) => c.commentId), [1]);
  });

  test('숨길 댓글이 없으면 그대로 전체 목록을 반환한다', () async {
    when(() => repository.getComments(1)).thenAnswer(
      (_) async => [_comment(commentId: 1), _comment(commentId: 2)],
    );

    final result = await useCase.call(1);

    expect(result, hasLength(2));
  });
}
