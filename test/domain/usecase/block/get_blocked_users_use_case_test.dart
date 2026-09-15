import 'package:ddara/domain/model/block/blocked_users.dart';
import 'package:ddara/domain/repository/block_repository.dart';
import 'package:ddara/domain/usecase/block/get_blocked_users_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBlockRepository extends Mock implements BlockRepository {}

void main() {
  late MockBlockRepository repository;
  late GetBlockedUsersUseCase useCase;

  setUp(() {
    repository = MockBlockRepository();
    useCase = GetBlockedUsersUseCase(repository);
  });

  test('Repository 의 결과를 그대로 반환한다', () async {
    const blockedUsers = BlockedUsers(users: []);
    when(() => repository.getBlockedUsers()).thenAnswer((_) async => blockedUsers);

    final result = await useCase.call();

    expect(result, blockedUsers);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.getBlockedUsers()).thenThrow(Exception('fail'));

    expect(() => useCase.call(), throwsA(isA<Exception>()));
  });
}
