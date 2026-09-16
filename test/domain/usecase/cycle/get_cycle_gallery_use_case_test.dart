import 'package:ddara/domain/model/group/cycle_gallery.dart';
import 'package:ddara/domain/repository/cycle_repository.dart';
import 'package:ddara/domain/usecase/cycle/get_cycle_gallery_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCycleRepository extends Mock implements CycleRepository {}

CycleGallery _gallery() {
  return CycleGallery(
    groupId: 1,
    groupName: 'group',
    cycle: CycleGalleryCycle(
      cycleId: 1,
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

void main() {
  late MockCycleRepository repository;
  late GetCycleGalleryUseCase useCase;

  setUp(() {
    repository = MockCycleRepository();
    useCase = GetCycleGalleryUseCase(repository);
  });

  test('cycleId 를 그대로 Repository 에 위임하고 결과를 반환한다', () async {
    final gallery = _gallery();
    when(() => repository.getCycleGallery(1)).thenAnswer((_) async => gallery);

    final result = await useCase.call(1);

    expect(result, gallery);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.getCycleGallery(any())).thenThrow(Exception('fail'));

    expect(() => useCase.call(1), throwsA(isA<Exception>()));
  });
}
