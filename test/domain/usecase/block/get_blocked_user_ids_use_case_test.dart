import 'package:ddara/domain/model/block/blocked_users.dart';
import 'package:ddara/domain/repository/block_repository.dart';
import 'package:ddara/domain/usecase/block/get_blocked_user_ids_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBlockRepository extends Mock implements BlockRepository {}

void main() {
  late MockBlockRepository repository;
  late GetBlockedUserIdsUseCase useCase;

  setUp(() {
    repository = MockBlockRepository();
    useCase = GetBlockedUserIdsUseCase(repository);
  });

  test('차단 유저 목록을 userId 집합으로 변환한다', () async {
    when(() => repository.getBlockedUsers()).thenAnswer(
      (_) async => BlockedUsers(
        users: [
          BlockedUser(
            userId: 1,
            name: 'a',
            blockedNickname: 'a-nick',
            blockedAt: DateTime(2026, 1, 1),
          ),
          BlockedUser(
            userId: 2,
            name: 'b',
            blockedNickname: 'b-nick',
            blockedAt: DateTime(2026, 1, 1),
          ),
        ],
      ),
    );

    final result = await useCase.call();

    expect(result, {1, 2});
  });

  test('조회가 실패해도 화면을 막지 않도록 빈 집합을 반환한다', () async {
    when(() => repository.getBlockedUsers()).thenThrow(Exception('network'));

    final result = await useCase.call();

    expect(result, isEmpty);
  });
}
