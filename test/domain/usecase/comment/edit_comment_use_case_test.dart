import 'package:ddara/domain/repository/comment_repository.dart';
import 'package:ddara/domain/usecase/comment/edit_comment_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late MockCommentRepository repository;
  late EditCommentUseCase useCase;

  setUp(() {
    repository = MockCommentRepository();
    useCase = EditCommentUseCase(repository);
  });

  test('commentId·content 를 그대로 위임하고 수정된 내용을 반환한다', () async {
    when(
      () => repository.editComment(commentId: 1, content: 'edited'),
    ).thenAnswer((_) async => 'edited');

    final result = await useCase.call(commentId: 1, content: 'edited');

    expect(result, 'edited');
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.editComment(
        commentId: any(named: 'commentId'),
        content: any(named: 'content'),
      ),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call(commentId: 1, content: 'edited'),
      throwsA(isA<Exception>()),
    );
  });
}
