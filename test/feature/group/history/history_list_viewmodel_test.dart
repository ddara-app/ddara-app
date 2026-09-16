import 'package:ddara/core/exception/group_action_error.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/domain/model/group/history_list.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/block/get_blocked_user_ids_use_case.dart';
import 'package:ddara/domain/usecase/group/get_history_list_use_case.dart';
import 'package:ddara/feature/group/history/history_list_viewmodel.dart';
import 'package:ddara/feature/group/history/provider/viewmodel_provider.dart';
import 'package:ddara/feature/group/history/util/history_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetHistoryListUseCase extends Mock implements GetHistoryListUseCase {}

class MockGetBlockedUserIdsUseCase extends Mock implements GetBlockedUserIdsUseCase {}

const _groupId = 1;

HistoryListViewModel notifierAlive(ProviderContainer container) {
  container.listen(historyListViewModelProvider(_groupId), (_, _) {});
  return container.read(historyListViewModelProvider(_groupId).notifier);
}

void main() {
  late MockGetHistoryListUseCase getHistoryList;
  late MockGetBlockedUserIdsUseCase getBlockedUserIds;
  late ProviderContainer container;

  setUp(() {
    getHistoryList = MockGetHistoryListUseCase();
    getBlockedUserIds = MockGetBlockedUserIdsUseCase();
    container = ProviderContainer(
      overrides: [
        getHistoryListUseCaseProvider.overrideWithValue(getHistoryList),
        getBlockedUserIdsUseCaseProvider.overrideWithValue(getBlockedUserIds),
      ],
    );
    addTearDown(container.dispose);
    when(() => getBlockedUserIds()).thenAnswer((_) async => <int>{});
  });

  test('조회 성공하면 HistoryListLoaded 로 전환한다', () async {
    when(
      () => getHistoryList(_groupId, year: null, month: null),
    ).thenAnswer(
      (_) async => const HistoryList(
        stats: HistoryStats(myCount: 1, totalCount: 2),
        cycles: [],
      ),
    );

    final notifier = notifierAlive(container);
    await notifier.applyFilter();

    final state = container.read(historyListViewModelProvider(_groupId));
    expect(state, isA<HistoryListLoaded>());
    expect((state as HistoryListLoaded).historyList.stats.myCount, 1);
  });

  test('최초 조회에서 GroupNotFoundException 이면 본문 에러로 전환한다', () async {
    when(
      () => getHistoryList(_groupId, year: null, month: null),
    ).thenAnswer((_) async => throw GroupNotFoundException());

    final notifier = notifierAlive(container);
    await notifier.applyFilter();

    final state = container.read(historyListViewModelProvider(_groupId));
    expect(state, isA<HistoryListLoadError>());
    expect((state as HistoryListLoadError).error, GroupActionError.groupNotFound);
  });

  test('목록이 떠 있는 상태의 필터 재조회 실패는 목록을 유지하고 actionError 만 채운다', () async {
    when(
      () => getHistoryList(_groupId, year: any(named: 'year'), month: any(named: 'month')),
    ).thenAnswer(
      (_) async => const HistoryList(
        stats: HistoryStats(myCount: 0, totalCount: 0),
        cycles: [],
      ),
    );

    final notifier = notifierAlive(container);
    await notifier.applyFilter();
    expect(container.read(historyListViewModelProvider(_groupId)), isA<HistoryListLoaded>());

    when(
      () => getHistoryList(_groupId, year: 2026, month: 1),
    ).thenAnswer((_) async => throw NotGroupMemberException());
    await notifier.applyFilter(year: 2026, month: 1);

    final state = container.read(historyListViewModelProvider(_groupId));
    expect(state, isA<HistoryListLoaded>());
    expect((state as HistoryListLoaded).actionError, GroupActionError.notGroupMember);
  });

  test('clearActionError 는 actionError 만 비운다', () async {
    when(
      () => getHistoryList(_groupId, year: null, month: null),
    ).thenAnswer(
      (_) async => const HistoryList(
        stats: HistoryStats(myCount: 0, totalCount: 0),
        cycles: [],
      ),
    );
    final notifier = notifierAlive(container);
    await notifier.applyFilter();

    when(
      () => getHistoryList(_groupId, year: 2026, month: 1),
    ).thenAnswer((_) async => throw Exception('fail'));
    await notifier.applyFilter(year: 2026, month: 1);
    expect(
      (container.read(historyListViewModelProvider(_groupId)) as HistoryListLoaded).actionError,
      isNotNull,
    );

    notifier.clearActionError();

    expect(
      (container.read(historyListViewModelProvider(_groupId)) as HistoryListLoaded).actionError,
      isNull,
    );
  });
}
