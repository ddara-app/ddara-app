import 'package:ddara/domain/model/cycle/starter_upload.dart';
import 'package:ddara/domain/repository/cycle_repository.dart';
import 'package:ddara/domain/usecase/cycle/starter_upload_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCycleRepository extends Mock implements CycleRepository {}

void main() {
  late MockCycleRepository repository;
  late StarterUploadUseCase useCase;

  setUp(() {
    repository = MockCycleRepository();
    useCase = StarterUploadUseCase(repository);
  });

  test('groupId·topic·path 를 그대로 Repository 에 위임한다', () async {
    const upload = StarterUpload(cycleId: 1);
    when(
      () => repository.uploadStarter(1, 'topic', '/path'),
    ).thenAnswer((_) async => upload);

    final result = await useCase.call(1, 'topic', '/path');

    expect(result, upload);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.uploadStarter(any(), any(), any()),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call(1, 'topic', '/path'),
      throwsA(isA<Exception>()),
    );
  });
}
