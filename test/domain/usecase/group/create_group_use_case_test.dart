import 'package:ddara/domain/model/group/create_group.dart';
import 'package:ddara/domain/repository/group_repository.dart';
import 'package:ddara/domain/usecase/group/create_group_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late CreateGroupUseCase useCase;

  setUp(() {
    repository = MockGroupRepository();
    useCase = CreateGroupUseCase(repository);
  });

  test('groupName·description·nickName 을 그대로 Repository 에 위임한다', () async {
    const created = CreateGroup(groupId: 1);
    when(
      () => repository.createGroup('name', 'desc', 'nick'),
    ).thenAnswer((_) async => created);

    final result = await useCase.call('name', 'desc', 'nick');

    expect(result, created);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.createGroup(any(), any(), any()),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call('name', 'desc', 'nick'),
      throwsA(isA<Exception>()),
    );
  });
}
