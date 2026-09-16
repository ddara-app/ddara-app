import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/group_join_error_code.dart';
import 'package:ddara/domain/model/group/join_group.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/group/join_group_use_case.dart';
import 'package:ddara/feature/group_join/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockJoinGroupUseCase extends Mock implements JoinGroupUseCase {}

void main() {
  late MockJoinGroupUseCase useCase;
  late ProviderContainer container;

  setUp(() {
    useCase = MockJoinGroupUseCase();
    container = ProviderContainer(
      overrides: [joinGroupUseCaseProvider.overrideWithValue(useCase)],
    );
    addTearDown(container.dispose);
    container.listen(joinGroupViewModelProvider, (_, _) {});
  });

  test('참여 성공하면 joinedGroupId 를 담는다', () async {
    final notifier = container.read(joinGroupViewModelProvider.notifier);
    notifier.nicknameOnChanged('nick');
    when(() => useCase('ABC123', 'nick')).thenAnswer(
      (_) async => const JoinGroup(groupId: 7),
    );

    await notifier.joinGroup('ABC123');

    final state = container.read(joinGroupViewModelProvider);
    expect(state.isLoading, false);
    expect(state.joinedGroupId, 7);
  });

  test('DuplicateGroupNicknameException 이면 duplicateGroupNickname 에러로 전환한다', () async {
    final notifier = container.read(joinGroupViewModelProvider.notifier);
    when(
      () => useCase(any(), any()),
    ).thenAnswer((_) async => throw DuplicateGroupNicknameException());

    await notifier.joinGroup('ABC123');

    expect(
      container.read(joinGroupViewModelProvider).errorCode,
      GroupJoinErrorCode.duplicateGroupNickname,
    );
  });

  test('GroupFullException 이면 groupFull 에러로 전환한다', () async {
    final notifier = container.read(joinGroupViewModelProvider.notifier);
    when(
      () => useCase(any(), any()),
    ).thenAnswer((_) async => throw GroupFullException());

    await notifier.joinGroup('ABC123');

    expect(container.read(joinGroupViewModelProvider).errorCode, GroupJoinErrorCode.groupFull);
  });

  test('예상 밖 예외는 unknown 에러로 전환한다', () async {
    final notifier = container.read(joinGroupViewModelProvider.notifier);
    when(
      () => useCase(any(), any()),
    ).thenAnswer((_) async => throw Exception('boom'));

    await notifier.joinGroup('ABC123');

    expect(container.read(joinGroupViewModelProvider).errorCode, GroupJoinErrorCode.unknown);
  });

  test('로딩 중 재호출은 무시한다', () async {
    final notifier = container.read(joinGroupViewModelProvider.notifier);
    when(() => useCase(any(), any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 30));
      return const JoinGroup(groupId: 1);
    });

    final first = notifier.joinGroup('ABC123');
    await notifier.joinGroup('ABC123');
    await first;

    verify(() => useCase(any(), any())).called(1);
  });
}
