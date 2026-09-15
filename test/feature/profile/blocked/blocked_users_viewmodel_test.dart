import 'package:ddara/domain/model/block/blocked_users.dart';
import 'package:ddara/domain/model/group/group_list.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/block/get_blocked_user_ids_use_case.dart';
import 'package:ddara/domain/usecase/block/get_blocked_users_use_case.dart';
import 'package:ddara/domain/usecase/block/unblock_user_use_case.dart';
import 'package:ddara/domain/usecase/group/get_group_list_use_case.dart';
import 'package:ddara/feature/profile/blocked/blocked_users_viewmodel.dart';
import 'package:ddara/feature/profile/blocked/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBlockedUsersUseCase extends Mock implements GetBlockedUsersUseCase {}

class MockUnblockUserUseCase extends Mock implements UnblockUserUseCase {}

class MockGetGroupListUseCase extends Mock implements GetGroupListUseCase {}

class MockGetBlockedUserIdsUseCase extends Mock implements GetBlockedUserIdsUseCase {}

/// 마이크로태스크 큐를 비운다. (usecase 의 async 응답이 state 에 반영될 때까지 대기)
Future<void> pump() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

/// autoDispose 는 구독자가 없으면 폐기되어 build() 이후의 비동기 응답이
/// 버려진다. 빈 리스너를 붙여 테스트 동안 살아있게 한 뒤 notifier 를 반환한다.
BlockedUsersViewModel notifierAlive(ProviderContainer container) {
  container.listen(blockedUsersViewModelProvider, (_, _) {});
  return container.read(blockedUsersViewModelProvider.notifier);
}

void main() {
  late MockGetBlockedUsersUseCase getBlockedUsers;
  late MockUnblockUserUseCase unblockUser;
  late ProviderContainer container;

  setUp(() {
    getBlockedUsers = MockGetBlockedUsersUseCase();
    unblockUser = MockUnblockUserUseCase();
    container = ProviderContainer(
      overrides: [
        getBlockedUsersUseCaseProvider.overrideWithValue(getBlockedUsers),
        unblockUserUseCaseProvider.overrideWithValue(unblockUser),
        // unblock() 성공 시 homeViewModelProvider 를 invalidate 하는데, 이
        // provider 가 한 번도 읽힌 적 없으면 invalidate 가 즉시 build() 를
        // 태워 실제 usecase 체인(Dio 등)을 건드린다. 무해한 값으로 막아둔다.
        getGroupListUseCaseProvider.overrideWithValue(MockGetGroupListUseCase()),
        getBlockedUserIdsUseCaseProvider.overrideWithValue(MockGetBlockedUserIdsUseCase()),
      ],
    );
    addTearDown(container.dispose);

    final groupListUseCase =
        container.read(getGroupListUseCaseProvider) as MockGetGroupListUseCase;
    when(() => groupListUseCase()).thenAnswer((_) async => const GroupList(groups: []));
    final blockedIdsUseCase =
        container.read(getBlockedUserIdsUseCaseProvider) as MockGetBlockedUserIdsUseCase;
    when(() => blockedIdsUseCase()).thenAnswer((_) async => <int>{});
  });

  test('진입 시 조회해 isLoading 이 false 로 바뀌고 목록을 담는다', () async {
    final users = BlockedUsers(
      users: [
        BlockedUser(userId: 1, name: 'a', blockedNickname: 'a-nick', blockedAt: DateTime(2026, 1, 1)),
      ],
    );
    when(() => getBlockedUsers()).thenAnswer((_) async => users);

    notifierAlive(container);
    await pump();

    final state = container.read(blockedUsersViewModelProvider);
    expect(state.isLoading, false);
    expect(state.blockedUsers?.users, hasLength(1));
  });

  test('조회 실패하면 isLoading 만 false 로 바뀌고 blockedUsers 는 null 로 남는다', () async {
    when(() => getBlockedUsers()).thenAnswer((_) async => throw Exception('fail'));

    notifierAlive(container);
    await pump();

    final state = container.read(blockedUsersViewModelProvider);
    expect(state.isLoading, false);
    expect(state.blockedUsers, isNull);
  });

  test('unblock 성공하면 해당 유저만 목록에서 제거하고 true 를 반환한다', () async {
    final users = BlockedUsers(
      users: [
        BlockedUser(userId: 1, name: 'a', blockedNickname: 'a-nick', blockedAt: DateTime(2026, 1, 1)),
        BlockedUser(userId: 2, name: 'b', blockedNickname: 'b-nick', blockedAt: DateTime(2026, 1, 1)),
      ],
    );
    when(() => getBlockedUsers()).thenAnswer((_) async => users);
    when(() => unblockUser(1)).thenAnswer((_) async {});

    final notifier = notifierAlive(container);
    await pump();

    final result = await notifier.unblock(1);

    expect(result, true);
    final state = container.read(blockedUsersViewModelProvider);
    expect(state.blockedUsers?.users.map((u) => u.userId), [2]);
    expect(state.unblockingUserIds, isEmpty);
  });

  test('unblock 실패하면 false 를 반환하고 목록은 그대로 유지한다', () async {
    final users = BlockedUsers(
      users: [
        BlockedUser(userId: 1, name: 'a', blockedNickname: 'a-nick', blockedAt: DateTime(2026, 1, 1)),
      ],
    );
    when(() => getBlockedUsers()).thenAnswer((_) async => users);
    when(() => unblockUser(any())).thenThrow(Exception('fail'));

    final notifier = notifierAlive(container);
    await pump();

    final result = await notifier.unblock(1);

    expect(result, false);
    final state = container.read(blockedUsersViewModelProvider);
    expect(state.blockedUsers?.users, hasLength(1));
    expect(state.unblockingUserIds, isEmpty);
  });

  test('같은 userId 의 차단 해제가 진행 중이면 중복 호출을 막는다', () async {
    final users = BlockedUsers(
      users: [
        BlockedUser(userId: 1, name: 'a', blockedNickname: 'a-nick', blockedAt: DateTime(2026, 1, 1)),
      ],
    );
    when(() => getBlockedUsers()).thenAnswer((_) async => users);
    when(() => unblockUser(1)).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 30));
    });

    final notifier = notifierAlive(container);
    await pump();

    final first = notifier.unblock(1);
    final second = await notifier.unblock(1);

    expect(second, false);
    await first;
    verify(() => unblockUser(1)).called(1);
  });
}
