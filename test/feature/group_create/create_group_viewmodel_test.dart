import 'package:ddara/core/exception/group_create_error.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/domain/model/group/create_group.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/group/create_group_use_case.dart';
import 'package:ddara/feature/group_create/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateGroupUseCase extends Mock implements CreateGroupUseCase {}

void main() {
  late MockCreateGroupUseCase useCase;
  late ProviderContainer container;

  setUp(() {
    useCase = MockCreateGroupUseCase();
    container = ProviderContainer(
      overrides: [createGroupUseCaseProvider.overrideWithValue(useCase)],
    );
    addTearDown(container.dispose);
    container.listen(createGroupViewModelProvider, (_, _) {});
  });

  test('groupNameOnChanged 는 이름을 갱신하고 이전 에러를 지운다', () {
    final notifier = container.read(createGroupViewModelProvider.notifier);

    notifier.groupNameOnChanged('모임이름');

    expect(container.read(createGroupViewModelProvider).groupName, '모임이름');
  });

  test('createGroup 성공하면 createGroupId 를 담고 로딩을 내린다', () async {
    final notifier = container.read(createGroupViewModelProvider.notifier);
    notifier.groupNameOnChanged('name');
    notifier.descriptionOnChanged('desc');
    notifier.nicknameOnChanged('nick');
    when(
      () => useCase('name', 'desc', 'nick'),
    ).thenAnswer((_) async => const CreateGroup(groupId: 5));

    await notifier.createGroup();

    final state = container.read(createGroupViewModelProvider);
    expect(state.isLoading, false);
    expect(state.createGroupId, 5);
  });

  test('InvalidGroupNameException 이면 invalidName 에러로 전환한다', () async {
    final notifier = container.read(createGroupViewModelProvider.notifier);
    when(
      () => useCase(any(), any(), any()),
    ).thenAnswer((_) async => throw InvalidGroupNameException());

    await notifier.createGroup();

    final state = container.read(createGroupViewModelProvider);
    expect(state.isLoading, false);
    expect(state.errorCode, GroupCreateError.invalidName);
  });

  test('GroupLimitExceededException 이면 limitExceeded 에러로 전환한다', () async {
    final notifier = container.read(createGroupViewModelProvider.notifier);
    when(
      () => useCase(any(), any(), any()),
    ).thenAnswer((_) async => throw GroupLimitExceededException());

    await notifier.createGroup();

    expect(container.read(createGroupViewModelProvider).errorCode, GroupCreateError.limitExceeded);
  });

  test('예상 밖 예외는 unknown 에러로 전환해 버튼 잠김을 막는다', () async {
    final notifier = container.read(createGroupViewModelProvider.notifier);
    when(
      () => useCase(any(), any(), any()),
    ).thenAnswer((_) async => throw Exception('boom'));

    await notifier.createGroup();

    final state = container.read(createGroupViewModelProvider);
    expect(state.isLoading, false);
    expect(state.errorCode, GroupCreateError.unknown);
  });

  test('로딩 중 재호출은 무시한다', () async {
    final notifier = container.read(createGroupViewModelProvider.notifier);
    when(() => useCase(any(), any(), any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 30));
      return const CreateGroup(groupId: 1);
    });

    final first = notifier.createGroup();
    await notifier.createGroup();
    await first;

    verify(() => useCase(any(), any(), any())).called(1);
  });
}
