import 'package:ddara/domain/model/camera/camera_guide_key.dart';
import 'package:ddara/domain/repository/profile_repository.dart';
import 'package:ddara/domain/usecase/profile/complete_camera_guide_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late CompleteCameraGuideUseCase useCase;

  setUpAll(() {
    registerFallbackValue(CameraGuideKey.miniView);
  });

  setUp(() {
    repository = MockProfileRepository();
    useCase = CompleteCameraGuideUseCase(repository);
  });

  test('key 를 그대로 Repository 에 위임한다', () async {
    when(
      () => repository.completeCameraGuide(CameraGuideKey.ghostView),
    ).thenAnswer((_) async {});

    await useCase.call(CameraGuideKey.ghostView);

    verify(() => repository.completeCameraGuide(CameraGuideKey.ghostView)).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.completeCameraGuide(any()),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call(CameraGuideKey.miniView),
      throwsA(isA<Exception>()),
    );
  });
}
