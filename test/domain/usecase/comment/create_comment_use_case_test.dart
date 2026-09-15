import 'package:ddara/domain/model/comment/comment.dart';
import 'package:ddara/domain/repository/comment_repository.dart';
import 'package:ddara/domain/usecase/comment/create_comment_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late MockCommentRepository repository;
  late CreateCommentUseCase useCase;

  setUp(() {
    repository = MockCommentRepository();
    useCase = CreateCommentUseCase(repository);
  });

  test('shotId·content 를 그대로 Repository 에 위임하고 생성된 댓글을 반환한다', () async {
    final comment = Comment(
      commentId: 1,
      userId: 1,
      nickname: 'nick',
      profileImageUrl: null,
      content: 'hi',
      createdAt: DateTime(2026, 1, 1),
    );
    when(
      () => repository.createComment(shotId: 1, content: 'hi'),
    ).thenAnswer((_) async => comment);

    final result = await useCase.call(shotId: 1, content: 'hi');

    expect(result, comment);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.createComment(
        shotId: any(named: 'shotId'),
        content: any(named: 'content'),
      ),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call(shotId: 1, content: 'hi'),
      throwsA(isA<Exception>()),
    );
  });
}
