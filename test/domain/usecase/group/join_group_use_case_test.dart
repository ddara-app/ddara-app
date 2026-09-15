import 'package:ddara/domain/model/group/join_group.dart';
import 'package:ddara/domain/repository/group_repository.dart';
import 'package:ddara/domain/usecase/group/join_group_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late JoinGroupUseCase useCase;

  setUp(() {
    repository = MockGroupRepository();
    useCase = JoinGroupUseCase(repository);
  });

  test('inviteCode·nickName 을 그대로 Repository 에 위임한다', () async {
    const joined = JoinGroup(groupId: 1);
    when(
      () => repository.joinGroup('ABC123', 'nick'),
    ).thenAnswer((_) async => joined);

    final result = await useCase.call('ABC123', 'nick');

    expect(result, joined);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.joinGroup(any(), any()),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call('ABC123', 'nick'),
      throwsA(isA<Exception>()),
    );
  });
}
