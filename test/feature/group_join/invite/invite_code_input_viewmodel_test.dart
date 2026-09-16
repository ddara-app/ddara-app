import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/group_join_error_code.dart';
import 'package:ddara/domain/model/group/invite_group.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/group/get_invite_group_use_case.dart';
import 'package:ddara/feature/group_join/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetInviteGroupUseCase extends Mock implements GetInviteGroupUseCase {}

InviteGroup _invite({bool alreadyJoined = false, bool isFull = false}) {
  return InviteGroup(
    groupId: 1,
    name: 'group',
    ownerNickname: 'owner',
    memberCount: 2,
    isFull: isFull,
    memberAvatars: const [],
    alreadyJoined: alreadyJoined,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  late MockGetInviteGroupUseCase useCase;
  late ProviderContainer container;

  setUp(() {
    useCase = MockGetInviteGroupUseCase();
    container = ProviderContainer(
      overrides: [getInviteGroupUseCaseProvider.overrideWithValue(useCase)],
    );
    addTearDown(container.dispose);
    container.listen(inviteCodeInputViewModelProvider, (_, _) {});
  });

  test('조회 성공하면 inviteGroup 을 담는다', () async {
    final notifier = container.read(inviteCodeInputViewModelProvider.notifier);
    notifier.inviteCodeOnChanged('ABC123');
    when(() => useCase('ABC123')).thenAnswer((_) async => _invite());

    await notifier.fetchInviteGroup();

    final state = container.read(inviteCodeInputViewModelProvider);
    expect(state.isLoading, false);
    expect(state.inviteGroup, isNotNull);
  });

  test('이미 참여 중인 모임이면 alreadyJoinedGroup 에러로 전환하고 inviteGroup 은 담지 않는다', () async {
    final notifier = container.read(inviteCodeInputViewModelProvider.notifier);
    notifier.inviteCodeOnChanged('ABC123');
    when(() => useCase(any())).thenAnswer((_) async => _invite(alreadyJoined: true));

    await notifier.fetchInviteGroup();

    final state = container.read(inviteCodeInputViewModelProvider);
    expect(state.errorCode, GroupJoinErrorCode.alreadyJoinedGroup);
    expect(state.inviteGroup, isNull);
  });

  test('정원이 가득 찼으면 groupFull 에러로 전환한다', () async {
    final notifier = container.read(inviteCodeInputViewModelProvider.notifier);
    notifier.inviteCodeOnChanged('ABC123');
    when(() => useCase(any())).thenAnswer((_) async => _invite(isFull: true));

    await notifier.fetchInviteGroup();

    expect(container.read(inviteCodeInputViewModelProvider).errorCode, GroupJoinErrorCode.groupFull);
  });

  test('InvalidInviteCodeException 이면 invalidInviteCode 에러로 전환한다', () async {
    final notifier = container.read(inviteCodeInputViewModelProvider.notifier);
    when(
      () => useCase(any()),
    ).thenAnswer((_) async => throw InvalidInviteCodeException());

    await notifier.fetchInviteGroup();

    expect(
      container.read(inviteCodeInputViewModelProvider).errorCode,
      GroupJoinErrorCode.invalidInviteCode,
    );
  });

  test('inviteCodeOnChanged 는 이전 조회 결과와 에러를 함께 비운다', () async {
    final notifier = container.read(inviteCodeInputViewModelProvider.notifier);
    when(() => useCase(any())).thenAnswer((_) async => _invite());
    await notifier.fetchInviteGroup();
    expect(container.read(inviteCodeInputViewModelProvider).inviteGroup, isNotNull);

    notifier.inviteCodeOnChanged('NEWCODE');

    final state = container.read(inviteCodeInputViewModelProvider);
    expect(state.inviteGroup, isNull);
    expect(state.errorCode, isNull);
  });
}
