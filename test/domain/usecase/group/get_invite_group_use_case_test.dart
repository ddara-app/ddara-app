import 'package:ddara/domain/model/group/invite_group.dart';
import 'package:ddara/domain/repository/group_repository.dart';
import 'package:ddara/domain/usecase/group/get_invite_group_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late GetInviteGroupUseCase useCase;

  setUp(() {
    repository = MockGroupRepository();
    useCase = GetInviteGroupUseCase(repository);
  });

  test('inviteCode 를 그대로 Repository 에 위임하고 결과를 반환한다', () async {
    final invite = InviteGroup(
      groupId: 1,
      name: 'group',
      ownerNickname: 'owner',
      memberCount: 2,
      isFull: false,
      memberAvatars: const [],
      alreadyJoined: false,
      createdAt: DateTime(2026, 1, 1),
    );
    when(
      () => repository.getInviteGroup('ABC123'),
    ).thenAnswer((_) async => invite);

    final result = await useCase.call('ABC123');

    expect(result, invite);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.getInviteGroup(any()),
    ).thenThrow(Exception('fail'));

    expect(() => useCase.call('ABC123'), throwsA(isA<Exception>()));
  });
}
