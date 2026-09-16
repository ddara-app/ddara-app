import 'package:ddara/core/exception/block_exception.dart';
import 'package:ddara/core/exception/group_action_error.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/domain/model/comment/comment.dart';
import 'package:ddara/domain/model/group/cycle_gallery.dart';
import 'package:ddara/domain/model/group/group_list.dart';
import 'package:ddara/domain/model/profile/profile.dart';
import 'package:ddara/domain/model/report/report_reason.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/block/block_user_use_case.dart';
import 'package:ddara/domain/usecase/block/get_blocked_user_ids_use_case.dart';
import 'package:ddara/domain/usecase/comment/get_comments_use_case.dart';
import 'package:ddara/domain/usecase/comment/mark_comments_read_use_case.dart';
import 'package:ddara/domain/usecase/cycle/get_cycle_gallery_use_case.dart';
import 'package:ddara/domain/usecase/profile/get_profile_use_case.dart';
import 'package:ddara/domain/usecase/report/report_shot_use_case.dart';
import 'package:ddara/feature/group/gallery/cycle_photo_gallery_viewmodel.dart';
import 'package:ddara/feature/group/gallery/provider/viewmodel_provider.dart';
import 'package:ddara/feature/group/gallery/util/cycle_photo_gallery_state.dart';
import 'package:ddara/domain/usecase/group/get_group_list_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCycleGalleryUseCase extends Mock implements GetCycleGalleryUseCase {}

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockGetBlockedUserIdsUseCase extends Mock implements GetBlockedUserIdsUseCase {}

class MockReportShotUseCase extends Mock implements ReportShotUseCase {}

class MockBlockUserUseCase extends Mock implements BlockUserUseCase {}

class MockMarkCommentsReadUseCase extends Mock implements MarkCommentsReadUseCase {}

class MockGetCommentsUseCase extends Mock implements GetCommentsUseCase {}

class MockGetGroupListUseCase extends Mock implements GetGroupListUseCase {}

const _cycleId = 1;

CycleGallery _gallery({int groupId = 10}) {
  return CycleGallery(
    groupId: groupId,
    groupName: 'group',
    cycle: CycleGalleryCycle(
      cycleId: _cycleId,
      cycleNumber: 1,
      topic: 'topic',
      starterUserId: 1,
      starterNickname: 'starter',
      starterShotId: 1,
      starterImageUrl: 'https://img',
      starterImageUnderReview: false,
      hasUnreadComments: false,
      status: 'in_progress',
      deadlineAt: DateTime(2026, 1, 2),
    ),
    viewerUploaded: true,
    members: const [],
  );
}

CyclePhotoGalleryViewModel notifierAlive(ProviderContainer container) {
  container.listen(cyclePhotoGalleryViewModelProvider(_cycleId), (_, _) {});
  return container.read(cyclePhotoGalleryViewModelProvider(_cycleId).notifier);
}

void main() {
  late MockGetCycleGalleryUseCase getCycleGallery;
  late MockGetProfileUseCase getProfile;
  late MockGetBlockedUserIdsUseCase getBlockedUserIds;
  late MockReportShotUseCase reportShot;
  late MockBlockUserUseCase blockUser;
  late MockMarkCommentsReadUseCase markCommentsRead;
  late MockGetCommentsUseCase getComments;
  late MockGetGroupListUseCase getGroupList;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(ReportReason.obscene);
  });

  setUp(() {
    getCycleGallery = MockGetCycleGalleryUseCase();
    getProfile = MockGetProfileUseCase();
    getBlockedUserIds = MockGetBlockedUserIdsUseCase();
    reportShot = MockReportShotUseCase();
    blockUser = MockBlockUserUseCase();
    markCommentsRead = MockMarkCommentsReadUseCase();
    getComments = MockGetCommentsUseCase();
    getGroupList = MockGetGroupListUseCase();
    container = ProviderContainer(
      overrides: [
        getCycleGalleryUseCaseProvider.overrideWithValue(getCycleGallery),
        getProfileUseCaseProvider.overrideWithValue(getProfile),
        getBlockedUserIdsUseCaseProvider.overrideWithValue(getBlockedUserIds),
        reportShotUseCaseProvider.overrideWithValue(reportShot),
        blockUserUseCaseProvider.overrideWithValue(blockUser),
        markCommentsReadUseCaseProvider.overrideWithValue(markCommentsRead),
        getCommentsUseCaseProvider.overrideWithValue(getComments),
        // blockMember 성공 시 homeViewModelProvider 를 invalidate 하는데,
        // 한 번도 읽힌 적 없으면 즉시 build() 가 돌아 실제 usecase 체인을
        // 건드린다. 무해한 값으로 막아둔다.
        getGroupListUseCaseProvider.overrideWithValue(getGroupList),
      ],
    );
    addTearDown(container.dispose);
    when(() => getProfile()).thenAnswer(
      (_) async => Profile(
        id: 100,
        name: 'me',
        profileImageUrl: null,
        provider: 'KAKAO',
        createdAt: DateTime(2026, 1, 1),
      ),
    );
    when(() => getBlockedUserIds()).thenAnswer((_) async => <int>{});
    when(() => getGroupList()).thenAnswer((_) async => const GroupList(groups: []));
  });

  test('조회 성공하면 CyclePhotoGalleryLoaded 로 전환하고 myUserId 를 담는다', () async {
    when(() => getCycleGallery(_cycleId)).thenAnswer((_) async => _gallery());

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(cyclePhotoGalleryViewModelProvider(_cycleId));
    expect(state, isA<CyclePhotoGalleryLoaded>());
    expect((state as CyclePhotoGalleryLoaded).myUserId, 100);
  });

  test('NotGroupMemberException 이면 notGroupMember 본문 에러로 전환한다', () async {
    when(() => getCycleGallery(_cycleId)).thenAnswer((_) async => throw NotGroupMemberException());

    notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(cyclePhotoGalleryViewModelProvider(_cycleId));
    expect(state, isA<CyclePhotoGalleryLoadError>());
    expect((state as CyclePhotoGalleryLoadError).error, GroupActionError.notGroupMember);
  });

  test('reportShot 성공하면 갤러리를 재조회하고 true 를 반환한다', () async {
    when(() => getCycleGallery(_cycleId)).thenAnswer((_) async => _gallery());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(
      () => reportShot(shotId: any(named: 'shotId'), reason: any(named: 'reason'), reasonText: any(named: 'reasonText')),
    ).thenAnswer((_) async {});

    final result = await notifier.reportShot(shotId: 1, reason: ReportReason.obscene);

    expect(result, true);
    verify(() => getCycleGallery(_cycleId)).called(greaterThan(1));
    final state = container.read(cyclePhotoGalleryViewModelProvider(_cycleId)) as CyclePhotoGalleryLoaded;
    expect(state.isBusy, false);
  });

  test('reportShot 이 ShotNotFoundException 이면 reportShotNotFound 로 전환하고 false 를 반환한다', () async {
    when(() => getCycleGallery(_cycleId)).thenAnswer((_) async => _gallery());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(
      () => reportShot(shotId: any(named: 'shotId'), reason: any(named: 'reason'), reasonText: any(named: 'reasonText')),
    ).thenAnswer((_) async => throw ShotNotFoundException());

    final result = await notifier.reportShot(shotId: 1, reason: ReportReason.obscene);

    expect(result, false);
    final state = container.read(cyclePhotoGalleryViewModelProvider(_cycleId)) as CyclePhotoGalleryLoaded;
    expect(state.actionError, GroupActionError.reportShotNotFound);
  });

  test('blockMember 성공하면 갤러리를 재조회하고 홈도 무효화한다', () async {
    when(() => getCycleGallery(_cycleId)).thenAnswer((_) async => _gallery(groupId: 10));
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(() => blockUser(1, groupId: 10)).thenAnswer((_) async {});

    final result = await notifier.blockMember(1);

    expect(result, true);
    verify(() => getCycleGallery(_cycleId)).called(greaterThan(1));
  });

  test('blockMember 이 InvalidBlockInputException 이면 blockSelf 로 전환한다', () async {
    when(() => getCycleGallery(_cycleId)).thenAnswer((_) async => _gallery());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(
      () => blockUser(any(), groupId: any(named: 'groupId')),
    ).thenAnswer((_) async => throw InvalidBlockInputException());

    final result = await notifier.blockMember(1);

    expect(result, false);
    final state = container.read(cyclePhotoGalleryViewModelProvider(_cycleId)) as CyclePhotoGalleryLoaded;
    expect(state.actionError, GroupActionError.blockSelf);
  });

  test('markCommentsRead 는 즉시 readShotIds 에 담고 서버에도 기록한다', () async {
    when(() => getCycleGallery(_cycleId)).thenAnswer((_) async => _gallery());
    when(() => markCommentsRead(any())).thenAnswer((_) async {});
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.markCommentsRead(5);

    final state = container.read(cyclePhotoGalleryViewModelProvider(_cycleId)) as CyclePhotoGalleryLoaded;
    expect(state.readShotIds, {5});
    verify(() => markCommentsRead(5)).called(1);
  });

  test('loadComments 는 갤러리 state 의 차단 목록으로 걸러낸다', () async {
    when(() => getBlockedUserIds()).thenAnswer((_) async => {2});
    when(() => getCycleGallery(_cycleId)).thenAnswer((_) async => _gallery());
    final notifier = notifierAlive(container);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    when(() => getComments(1)).thenAnswer(
      (_) async => [
        Comment(
          commentId: 1,
          userId: 2,
          nickname: 'blocked',
          profileImageUrl: null,
          content: 'hi',
          createdAt: DateTime(2026, 1, 1),
        ),
        Comment(
          commentId: 2,
          userId: 3,
          nickname: 'ok',
          profileImageUrl: null,
          content: 'hello',
          createdAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    final result = await notifier.loadComments(shotId: 1);

    expect(result?.map((c) => c.commentId), [2]);
  });
}
