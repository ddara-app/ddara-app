import 'package:ddara/domain/repository/block_repository.dart';
import 'package:ddara/domain/usecase/block/block_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBlockRepository extends Mock implements BlockRepository {}

void main() {
  late MockBlockRepository repository;
  late BlockUserUseCase useCase;

  setUp(() {
    repository = MockBlockRepository();
    useCase = BlockUserUseCase(repository);
  });

  test('userId·groupId 를 그대로 Repository 에 위임한다', () async {
    when(
      () => repository.blockUser(1, groupId: 2),
    ).thenAnswer((_) async {});

    await useCase.call(1, groupId: 2);

    verify(() => repository.blockUser(1, groupId: 2)).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.blockUser(any(), groupId: any(named: 'groupId')),
    ).thenThrow(Exception('fail'));

    expect(() => useCase.call(1, groupId: 2), throwsA(isA<Exception>()));
  });
}
