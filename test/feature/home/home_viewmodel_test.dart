import 'package:ddara/domain/model/group/group_list.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/block/block_user_use_case.dart';
import 'package:ddara/domain/usecase/block/get_blocked_user_ids_use_case.dart';
import 'package:ddara/domain/usecase/group/get_group_list_use_case.dart';
import 'package:ddara/feature/home/home_viewmodel.dart';
import 'package:ddara/feature/home/provider/viewmodel_provider.dart';
import 'package:ddara/feature/home/util/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGroupListUseCase extends Mock implements GetGroupListUseCase {}

class MockGetBlockedUserIdsUseCase extends Mock implements GetBlockedUserIdsUseCase {}

class MockBlockUserUseCase extends Mock implements BlockUserUseCase {}

/// autoDispose 는 구독자가 없으면 폐기되어 _load() 의 await 이후 상태 대입이
/// 무시될 수 있다. 빈 리스너를 붙여 테스트 동안 살아있게 한 뒤 notifier 를
/// 반환한다. (build() 가 트리거하는 첫 _load() 는 기본 스텁을 쓰므로, 테스트가
/// 검증할 실패 스텁은 이 호출 전에 걸어야 "초기 조회" 의미가 유지된다)
HomeViewModel notifierAlive(ProviderContainer container) {
  container.listen(homeViewModelProvider, (_, _) {});
  return container.read(homeViewModelProvider.notifier);
}

void main() {
  late MockGetGroupListUseCase getGroupList;
  late MockGetBlockedUserIdsUseCase getBlockedUserIds;
  late MockBlockUserUseCase blockUser;
  late ProviderContainer container;

  setUp(() {
    getGroupList = MockGetGroupListUseCase();
    getBlockedUserIds = MockGetBlockedUserIdsUseCase();
    blockUser = MockBlockUserUseCase();
    container = ProviderContainer(
      overrides: [
        getGroupListUseCaseProvider.overrideWithValue(getGroupList),
        getBlockedUserIdsUseCaseProvider.overrideWithValue(getBlockedUserIds),
        blockUserUseCaseProvider.overrideWithValue(blockUser),
      ],
    );
    addTearDown(container.dispose);
  });

  test('조회 성공하면 모임 목록·차단 목록을 담아 HomeLoaded 로 전환한다', () async {
    when(() => getGroupList()).thenAnswer((_) async => const GroupList(groups: []));
    when(() => getBlockedUserIds()).thenAnswer((_) async => {1, 2});

    final notifier = notifierAlive(container);
    await notifier.refresh();

    final state = container.read(homeViewModelProvider);
    expect(state, isA<HomeLoaded>());
    expect((state as HomeLoaded).blockedUserIds, {1, 2});
  });

  test('초기 조회 실패는 HomeLoadError 로 전환한다', () async {
    when(() => getGroupList()).thenAnswer((_) async => throw Exception('fail'));
    when(() => getBlockedUserIds()).thenAnswer((_) async => <int>{});

    final notifier = notifierAlive(container);
    await notifier.refresh();

    expect(container.read(homeViewModelProvider), isA<HomeLoadError>());
  });

  test('이미 목록을 보고 있으면 재조회 실패해도 기존 목록을 유지한다', () async {
    when(() => getGroupList()).thenAnswer((_) async => const GroupList(groups: []));
    when(() => getBlockedUserIds()).thenAnswer((_) async => <int>{});

    final notifier = notifierAlive(container);
    await notifier.refresh();
    expect(container.read(homeViewModelProvider), isA<HomeLoaded>());

    when(() => getGroupList()).thenAnswer((_) async => throw Exception('fail'));
    await notifier.refresh();

    expect(container.read(homeViewModelProvider), isA<HomeLoaded>());
  });

  test('blockUser 성공하면 true 를 반환하고 홈을 다시 조회한다', () async {
    when(() => getGroupList()).thenAnswer((_) async => const GroupList(groups: []));
    when(() => getBlockedUserIds()).thenAnswer((_) async => <int>{});
    when(() => blockUser(1, groupId: 2)).thenAnswer((_) async {});

    final notifier = notifierAlive(container);
    await notifier.refresh();

    final result = await notifier.blockUser(1, groupId: 2);

    expect(result, true);
    verify(() => getGroupList()).called(greaterThan(1));
  });

  test('blockUser 실패하면 false 를 반환하고 화면 상태는 바꾸지 않는다', () async {
    when(() => getGroupList()).thenAnswer((_) async => const GroupList(groups: []));
    when(() => getBlockedUserIds()).thenAnswer((_) async => <int>{});
    when(() => blockUser(any(), groupId: any(named: 'groupId'))).thenThrow(Exception('fail'));

    final notifier = notifierAlive(container);
    await notifier.refresh();
    final before = container.read(homeViewModelProvider);

    final result = await notifier.blockUser(1, groupId: 2);

    expect(result, false);
    expect(container.read(homeViewModelProvider), same(before));
  });
}
