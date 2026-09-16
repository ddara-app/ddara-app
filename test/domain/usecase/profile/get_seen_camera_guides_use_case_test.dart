import 'package:ddara/domain/model/camera/camera_guide_key.dart';
import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:ddara/domain/usecase/profile/get_seen_camera_guides_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late GetSeenCameraGuidesUseCase useCase;

  setUp(() {
    repository = MockProfileRepository();
    useCase = GetSeenCameraGuidesUseCase(repository);
  });

  test('Repository 의 결과를 그대로 반환한다', () async {
    when(() => repository.getSeenCameraGuides()).thenAnswer(
      (_) async => {CameraGuideKey.miniView},
    );

    final result = await useCase.call();

    expect(result, {CameraGuideKey.miniView});
  });

  test('본 가이드가 없으면 빈 집합을 반환한다', () async {
    when(() => repository.getSeenCameraGuides()).thenAnswer((_) async => {});

    final result = await useCase.call();

    expect(result, isEmpty);
  });
}
