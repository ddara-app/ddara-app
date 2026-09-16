import 'package:ddara/core/exception/cycle_exception.dart';
import 'package:ddara/core/exception/group_action_error.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/domain/model/camera/camera_guide_key.dart';
import 'package:ddara/domain/model/cycle/follower_upload.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/cycle/follower_upload_use_case.dart';
import 'package:ddara/domain/usecase/profile/complete_camera_guide_use_case.dart';
import 'package:ddara/domain/usecase/profile/get_seen_camera_guides_use_case.dart';
import 'package:ddara/feature/group/follower/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFollowerUploadUseCase extends Mock implements FollowerUploadUseCase {}

class MockGetSeenCameraGuidesUseCase extends Mock implements GetSeenCameraGuidesUseCase {}

class MockCompleteCameraGuideUseCase extends Mock implements CompleteCameraGuideUseCase {}

void main() {
  late MockFollowerUploadUseCase uploadUseCase;
  late MockGetSeenCameraGuidesUseCase getSeenGuides;
  late MockCompleteCameraGuideUseCase completeGuide;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(CameraGuideKey.miniView);
  });

  setUp(() {
    uploadUseCase = MockFollowerUploadUseCase();
    getSeenGuides = MockGetSeenCameraGuidesUseCase();
    completeGuide = MockCompleteCameraGuideUseCase();
    container = ProviderContainer(
      overrides: [
        followerUploadUseCase.overrideWithValue(uploadUseCase),
        getSeenCameraGuidesUseCaseProvider.overrideWithValue(getSeenGuides),
        completeCameraGuideUseCaseProvider.overrideWithValue(completeGuide),
      ],
    );
    addTearDown(container.dispose);
    container.listen(followerViewModelProvider, (_, _) {});
    when(() => completeGuide(any())).thenAnswer((_) async {});
  });

  group('loadTourSeen', () {
    test('조회 성공하면 각 투어의 시청 여부를 담는다', () async {
      when(() => getSeenGuides()).thenAnswer(
        (_) async => {CameraGuideKey.miniView},
      );
      final notifier = container.read(followerViewModelProvider.notifier);

      await notifier.loadTourSeen();

      final state = container.read(followerViewModelProvider);
      expect(state.isCornerTourSeen, true);
      expect(state.isGhostTourSeen, false);
    });

    test('조회 실패하면 둘 다 못 본 것으로 둔다', () async {
      when(() => getSeenGuides()).thenAnswer((_) async => throw Exception('fail'));
      final notifier = container.read(followerViewModelProvider.notifier);

      await notifier.loadTourSeen();

      final state = container.read(followerViewModelProvider);
      expect(state.isCornerTourSeen, false);
      expect(state.isGhostTourSeen, false);
    });
  });

  group('completeCornerTour / completeGhostTour', () {
    test('처음 완료하면 상태를 갱신하고 서버에 기록한다', () async {
      final notifier = container.read(followerViewModelProvider.notifier);

      notifier.completeCornerTour();
      await Future<void>.delayed(Duration.zero);

      expect(container.read(followerViewModelProvider).isCornerTourSeen, true);
      verify(() => completeGuide(CameraGuideKey.miniView)).called(1);
    });

    test('이미 본 투어를 다시 완료해도 중복 기록하지 않는다', () async {
      when(() => getSeenGuides()).thenAnswer(
        (_) async => {CameraGuideKey.ghostView},
      );
      final notifier = container.read(followerViewModelProvider.notifier);
      await notifier.loadTourSeen();

      notifier.completeGhostTour();
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => completeGuide(CameraGuideKey.ghostView));
    });
  });

  group('upload', () {
    test('업로드 성공하면 cycleId 를 반환한다', () async {
      when(() => uploadUseCase(1, '/path.jpg')).thenAnswer(
        (_) async => const FollowerUpload(cycleId: 1),
      );
      final notifier = container.read(followerViewModelProvider.notifier);

      final result = await notifier.upload(1, '/path.jpg');

      expect(result, 1);
      expect(container.read(followerViewModelProvider).isLoading, false);
    });

    test('CycleNotFoundException 이면 cycleNotFound 에러로 전환한다', () async {
      when(
        () => uploadUseCase(any(), any()),
      ).thenAnswer((_) async => throw CycleNotFoundException());
      final notifier = container.read(followerViewModelProvider.notifier);

      final result = await notifier.upload(1, '/path.jpg');

      expect(result, isNull);
      expect(container.read(followerViewModelProvider).error, GroupActionError.cycleNotFound);
    });

    test('NotGroupMemberException 이면 notGroupMember 에러로 전환한다', () async {
      when(
        () => uploadUseCase(any(), any()),
      ).thenAnswer((_) async => throw NotGroupMemberException());
      final notifier = container.read(followerViewModelProvider.notifier);

      await notifier.upload(1, '/path.jpg');

      expect(container.read(followerViewModelProvider).error, GroupActionError.notGroupMember);
    });

    test('업로드 진행 중 재호출은 무시한다', () async {
      when(() => uploadUseCase(any(), any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const FollowerUpload(cycleId: 1);
      });
      final notifier = container.read(followerViewModelProvider.notifier);

      final first = notifier.upload(1, '/path.jpg');
      final second = await notifier.upload(1, '/path.jpg');

      expect(second, isNull);
      await first;
      verify(() => uploadUseCase(any(), any())).called(1);
    });
  });
}
