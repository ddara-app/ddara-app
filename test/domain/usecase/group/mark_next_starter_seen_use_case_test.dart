import 'package:ddara/domain/repository/group_repository.dart';
import 'package:ddara/domain/usecase/group/mark_next_starter_seen_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late MarkNextStarterSeenUseCase useCase;

  setUp(() {
    repository = MockGroupRepository();
    useCase = MarkNextStarterSeenUseCase(repository);
  });

  test('groupId 를 그대로 Repository 에 위임한다', () async {
    when(() => repository.markNextStarterSeen(1)).thenAnswer((_) async {});

    await useCase.call(1);

    verify(() => repository.markNextStarterSeen(1)).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.markNextStarterSeen(any()),
    ).thenThrow(Exception('fail'));

    expect(() => useCase.call(1), throwsA(isA<Exception>()));
  });
}
