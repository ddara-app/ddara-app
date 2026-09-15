import 'package:ddara/domain/model/cycle/follower_upload.dart';
import 'package:ddara/domain/repository/cycle_repository.dart';
import 'package:ddara/domain/usecase/cycle/follower_upload_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCycleRepository extends Mock implements CycleRepository {}

void main() {
  late MockCycleRepository repository;
  late FollowerUploadUseCase useCase;

  setUp(() {
    repository = MockCycleRepository();
    useCase = FollowerUploadUseCase(repository);
  });

  test('cycleId·path 를 그대로 Repository 에 위임한다', () async {
    const upload = FollowerUpload(cycleId: 2);
    when(
      () => repository.uploadFollower(2, '/path'),
    ).thenAnswer((_) async => upload);

    final result = await useCase.call(2, '/path');

    expect(result, upload);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.uploadFollower(any(), any()),
    ).thenThrow(Exception('fail'));

    expect(() => useCase.call(2, '/path'), throwsA(isA<Exception>()));
  });
}
