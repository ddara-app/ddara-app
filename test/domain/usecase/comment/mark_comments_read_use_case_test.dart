import 'package:ddara/domain/repository/comment_repository.dart';
import 'package:ddara/domain/usecase/comment/mark_comments_read_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late MockCommentRepository repository;
  late MarkCommentsReadUseCase useCase;

  setUp(() {
    repository = MockCommentRepository();
    useCase = MarkCommentsReadUseCase(repository);
  });

  test('shotId 를 그대로 Repository 에 위임한다', () async {
    when(() => repository.markCommentsRead(1)).thenAnswer((_) async {});

    await useCase.call(1);

    verify(() => repository.markCommentsRead(1)).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.markCommentsRead(any())).thenThrow(Exception('fail'));

    expect(() => useCase.call(1), throwsA(isA<Exception>()));
  });
}
