import 'package:ddara/domain/repository/block_repository.dart';
import 'package:ddara/domain/usecase/block/unblock_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBlockRepository extends Mock implements BlockRepository {}

void main() {
  late MockBlockRepository repository;
  late UnblockUserUseCase useCase;

  setUp(() {
    repository = MockBlockRepository();
    useCase = UnblockUserUseCase(repository);
  });

  test('userId 를 그대로 Repository 에 위임한다', () async {
    when(() => repository.unblockUser(1)).thenAnswer((_) async {});

    await useCase.call(1);

    verify(() => repository.unblockUser(1)).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.unblockUser(any())).thenThrow(Exception('fail'));

    expect(() => useCase.call(1), throwsA(isA<Exception>()));
  });
}
