import 'package:ddara/core/exception/block_exception.dart';
import 'package:ddara/core/exception/group_action_error.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/domain/model/group/change_nickname.dart';
import 'package:ddara/domain/model/group/group_detail.dart';
import 'package:ddara/domain/model/group/history_cycles.dart';
import 'package:ddara/domain/model/report/group_report_reason.dart';
import 'package:ddara/domain/model/report/user_report_reason.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/block/block_user_use_case.dart';
import 'package:ddara/domain/usecase/block/get_blocked_user_ids_use_case.dart';
import 'package:ddara/domain/usecase/group/change_nickname_use_case.dart';
import 'package:ddara/domain/usecase/group/exit_group_use_case.dart';
import 'package:ddara/domain/usecase/group/get_group_detail_use_case.dart';
import 'package:ddara/domain/usecase/group/get_history_cycles_use_case.dart';
import 'package:ddara/domain/usecase/report/report_group_use_case.dart';
import 'package:ddara/domain/usecase/report/report_user_use_case.dart';
import 'package:ddara/feature/group/detail/group_page_viewmodel.dart';
import 'package:ddara/feature/group/detail/provider/viewmodel_provider.dart';
import 'package:ddara/feature/group/detail/util/group_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGroupDetailUseCase extends Mock implements GetGroupDetailUseCase {}

class MockGetHistoryCyclesUseCase extends Mock implements GetHistoryCyclesUseCase {}

class MockGetBlockedUserIdsUseCase extends Mock implements GetBlockedUserIdsUseCase {}

class MockExitGroupUseCase extends Mock implements ExitGroupUseCase {}

class MockBlockUserUseCase extends Mock implements BlockUserUseCase {}

class MockChangeNicknameUseCase extends Mock implements ChangeNicknameUseCase {}

class MockReportUserUseCase extends Mock implements ReportUserUseCase {}

class MockReportGroupUseCase extends Mock implements ReportGroupUseCase {}

const _groupId = 1;

GroupDetail _detail({GroupNextStarter? nextStarter}) {
  return GroupDetail(
    groupId: _groupId,
    name: 'group',
    inviteCode: 'ABC123',
    members: const [],
    currentCycle: null,
    nextStarter: nextStarter,
    createdAt: DateTime(2026, 1, 1),
  );
}

GroupPageViewModel notifierAlive(ProviderContainer container) {
  container.listen(groupPageViewModelProvider(_groupId), (_, _) {});
  return container.read(groupPageViewModelProvider(_groupId).notifier);
}

void main() {
  late MockGetGroupDetailUseCase getGroupDetail;
  late MockGetHistoryCyclesUseCase getHistoryCycles;
  late MockGetBlockedUserIdsUseCase getBlockedUserIds;
  late MockExitGroupUseCase exitGroup;
  late MockBlockUserUseCase blockUser;
  late MockChangeNicknameUseCase changeNickname;
  late MockReportUserUseCase reportUser;
  late MockReportGroupUseCase reportGroup;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(UserReportReason.nickname);
    registerFallbackValue(GroupReportReason.etc);
  });

  setUp(() {
    getGroupDetail = MockGetGroupDetailUseCase();
    getHistoryCycles = MockGetHistoryCyclesUseCase();
    getBlockedUserIds = MockGetBlockedUserIdsUseCase();
    exitGroup = MockExitGroupUseCase();
    blockUser = MockBlockUserUseCase();
    changeNickname = MockChangeNicknameUseCase();
    reportUser = MockReportUserUseCase();
    reportGroup = MockReportGroupUseCase();
    container = ProviderContainer(
      overrides: [
        getGroupDetailUseCaseProvider.overrideWithValue(getGroupDetail),
        getHistoryCyclesUseCaseProvider.overrideWithValue(getHistoryCycles),
        getBlockedUserIdsUseCaseProvider.overrideWithValue(getBlockedUserIds),
        exitGroupUseCaseProvider.overrideWithValue(exitGroup),
        blockUserUseCaseProvider.overrideWithValue(blockUser),
        changeNicknameUseCaseProvider.overrideWithValue(changeNickname),
        reportUserUseCaseProvider.overrideWithValue(reportUser),
        reportGroupUseCaseProvider.overrideWithValue(reportGroup),
      ],
    );
    addTearDown(container.dispose);
    when(() => getBlockedUserIds()).thenAnswer((_) async => <int>{});
    when(() => getHistoryCycles(_groupId)).thenAnswer((_) async => const HistoryCycles(cycles: []));
  });

  test('조회 성공하면 GroupPageLoaded 로 전환한다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer((_) async => _detail());

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(groupPageViewModelProvider(_groupId));
    expect(state, isA<GroupPageLoaded>());
  });

  test('GroupNotFoundException 이면 groupNotFound 본문 에러로 전환한다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer((_) async => throw GroupNotFoundException());

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(groupPageViewModelProvider(_groupId));
    expect(state, isA<GroupPageLoadError>());
    expect((state as GroupPageLoadError).error, GroupActionError.groupNotFound);
  });

  test('markNextStarterSeen 은 로컬 상태만 갱신하고 재조회하지 않는다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer(
      (_) async => _detail(
        nextStarter: const GroupNextStarter(userId: 1, nickname: 'next', seen: false),
      ),
    );
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    notifier.markNextStarterSeen();

    final state = container.read(groupPageViewModelProvider(_groupId)) as GroupPageLoaded;
    expect(state.groupDetail.nextStarter?.seen, true);
    verify(() => getGroupDetail(_groupId)).called(1);
  });

  test('exitGroup 성공하면 true 를 반환한다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer((_) async => _detail());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(() => exitGroup(_groupId)).thenAnswer((_) async {});

    final result = await notifier.exitGroup();

    expect(result, true);
  });

  test('exitGroup 이 NotGroupMemberException 이면 false 를 반환하고 busy 를 내린다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer((_) async => _detail());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(() => exitGroup(any())).thenAnswer((_) async => throw NotGroupMemberException());

    final result = await notifier.exitGroup();

    expect(result, false);
    final state = container.read(groupPageViewModelProvider(_groupId)) as GroupPageLoaded;
    expect(state.isBusy, false);
    expect(state.actionError, GroupActionError.notGroupMember);
  });

  test('blockMember 성공하면 상세를 재조회하고 true 를 반환한다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer((_) async => _detail());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(() => blockUser(1, groupId: _groupId)).thenAnswer((_) async {});

    final result = await notifier.blockMember(1);

    expect(result, true);
    verify(() => getGroupDetail(_groupId)).called(greaterThan(1));
  });

  test('blockMember 이 BlockTargetNotFoundException 이면 blockTargetNotFound 로 전환한다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer((_) async => _detail());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(
      () => blockUser(any(), groupId: any(named: 'groupId')),
    ).thenAnswer((_) async => throw BlockTargetNotFoundException());

    final result = await notifier.blockMember(1);

    expect(result, false);
    final state = container.read(groupPageViewModelProvider(_groupId)) as GroupPageLoaded;
    expect(state.actionError, GroupActionError.blockTargetNotFound);
    expect(state.isBusy, false);
  });

  test('changeNickName 성공하면 상세를 재조회하고 true 를 반환한다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer((_) async => _detail());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(() => changeNickname(_groupId, '새닉네임')).thenAnswer((_) async => const ChangeNickName(nickname: '새닉네임'));

    final result = await notifier.changeNickName('새닉네임');

    expect(result, true);
    verify(() => getGroupDetail(_groupId)).called(greaterThan(1));
  });

  test('changeNickName 이 DuplicateGroupNicknameException 이면 nicknameDuplicate 로 전환한다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer((_) async => _detail());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(
      () => changeNickname(any(), any()),
    ).thenAnswer((_) async => throw DuplicateGroupNicknameException());

    final result = await notifier.changeNickName('중복닉네임');

    expect(result, false);
    final state = container.read(groupPageViewModelProvider(_groupId)) as GroupPageLoaded;
    expect(state.actionError, GroupActionError.nicknameDuplicate);
  });

  test('reportMember 성공하면 true 를 반환하고 본문은 건드리지 않는다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer((_) async => _detail());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(
      () => reportUser(
        userId: any(named: 'userId'),
        groupId: any(named: 'groupId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async {});

    final result = await notifier.reportMember(userId: 2, reason: UserReportReason.nickname);

    expect(result, true);
    // 신고는 화면에 바뀌는 값이 없어 재조회하지 않는다 — 최초 조회(1회)만 유지.
    verify(() => getGroupDetail(_groupId)).called(1);
  });

  test('reportGroup 이 InvalidReportInputException 이면 reportInvalidInput 로 전환한다', () async {
    when(() => getGroupDetail(_groupId)).thenAnswer((_) async => _detail());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(
      () => reportGroup(
        groupId: any(named: 'groupId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async => throw InvalidReportInputException());

    final result = await notifier.reportGroup(reason: GroupReportReason.etc);

    expect(result, false);
    final state = container.read(groupPageViewModelProvider(_groupId)) as GroupPageLoaded;
    expect(state.actionError, GroupActionError.reportInvalidInput);
  });
}
