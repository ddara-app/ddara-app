import 'package:ddara/core/exception/cycle_exception.dart';
import 'package:ddara/core/exception/group_action_error.dart';
import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/domain/model/cycle/starter_upload.dart';
import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/domain/usecase/cycle/starter_upload_use_case.dart';
import 'package:ddara/feature/group/starter/provider/viewmodel_provider.dart';
import 'package:ddara/feature/group/starter/util/starter_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStarterUploadUseCase extends Mock implements StarterUploadUseCase {}

void main() {
  late MockStarterUploadUseCase useCase;
  late ProviderContainer container;

  setUp(() {
    useCase = MockStarterUploadUseCase();
    container = ProviderContainer(
      overrides: [starterUploadUseCase.overrideWithValue(useCase)],
    );
    addTearDown(container.dispose);
    container.listen(starterViewModelProvider, (_, _) {});
  });

  test('초기 상태는 카메라 단계·빈 컨셉이다', () {
    final state = container.read(starterViewModelProvider);
    expect(state.step, StarterStep.camera);
    expect(state.concept, '');
    expect(state.photoPath, isNull);
  });

  test('capture 는 사진 경로를 담고 info 단계로 전환한다', () {
    final notifier = container.read(starterViewModelProvider.notifier);

    notifier.capture('/path.jpg');

    final state = container.read(starterViewModelProvider);
    expect(state.step, StarterStep.info);
    expect(state.photoPath, '/path.jpg');
  });

  test('촬영 전(photoPath 없음)에 upload 를 호출하면 아무 일도 하지 않는다', () async {
    final notifier = container.read(starterViewModelProvider.notifier);

    final result = await notifier.upload(1);

    expect(result, isNull);
    verifyNever(() => useCase(any(), any(), any()));
  });

  test('업로드 성공하면 cycleId 를 반환하고 isLoading 을 내린다', () async {
    final notifier = container.read(starterViewModelProvider.notifier);
    notifier.conceptChanged('topic');
    notifier.capture('/path.jpg');
    when(() => useCase(1, 'topic', '/path.jpg')).thenAnswer(
      (_) async => const StarterUpload(cycleId: 42),
    );

    final result = await notifier.upload(1);

    expect(result, 42);
    expect(container.read(starterViewModelProvider).isLoading, false);
  });

  test('CycleAlreadyInProgressException 이면 null 을 반환하고 에러를 상태에 담는다', () async {
    final notifier = container.read(starterViewModelProvider.notifier);
    notifier.capture('/path.jpg');
    when(
      () => useCase(any(), any(), any()),
    ).thenAnswer((_) async => throw CycleAlreadyInProgressException());

    final result = await notifier.upload(1);

    expect(result, isNull);
    final state = container.read(starterViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, GroupActionError.cycleAlreadyInProgress);
  });

  test('NotGroupMemberException 이면 notGroupMember 에러로 전환한다', () async {
    final notifier = container.read(starterViewModelProvider.notifier);
    notifier.capture('/path.jpg');
    when(
      () => useCase(any(), any(), any()),
    ).thenAnswer((_) async => throw NotGroupMemberException());

    await notifier.upload(1);

    expect(container.read(starterViewModelProvider).error, GroupActionError.notGroupMember);
  });

  test('업로드 진행 중 재호출은 무시한다(중복 전송 방지)', () async {
    final notifier = container.read(starterViewModelProvider.notifier);
    notifier.capture('/path.jpg');
    when(() => useCase(any(), any(), any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 30));
      return const StarterUpload(cycleId: 1);
    });

    final first = notifier.upload(1);
    final second = await notifier.upload(1);

    expect(second, isNull);
    await first;
    verify(() => useCase(any(), any(), any())).called(1);
  });

  test('clearError 는 error 만 비운다', () async {
    final notifier = container.read(starterViewModelProvider.notifier);
    notifier.capture('/path.jpg');
    when(
      () => useCase(any(), any(), any()),
    ).thenAnswer((_) async => throw NotGroupMemberException());
    await notifier.upload(1);
    expect(container.read(starterViewModelProvider).error, isNotNull);

    notifier.clearError();

    expect(container.read(starterViewModelProvider).error, isNull);
  });
}
