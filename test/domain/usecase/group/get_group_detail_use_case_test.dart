import 'package:ddara/domain/model/group/group_detail.dart';
import 'package:ddara/domain/repository/group_repository.dart';
import 'package:ddara/domain/usecase/group/get_group_detail_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late GetGroupDetailUseCase useCase;

  setUp(() {
    repository = MockGroupRepository();
    useCase = GetGroupDetailUseCase(repository);
  });

  test('groupId 를 그대로 Repository 에 위임하고 결과를 반환한다', () async {
    final detail = GroupDetail(
      groupId: 1,
      name: 'group',
      inviteCode: 'ABC123',
      members: const [],
      currentCycle: null,
      nextStarter: null,
      createdAt: DateTime(2026, 1, 1),
    );
    when(() => repository.getGroupDetail(1)).thenAnswer((_) async => detail);

    final result = await useCase.call(1);

    expect(result, detail);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.getGroupDetail(any())).thenThrow(Exception('fail'));

    expect(() => useCase.call(1), throwsA(isA<Exception>()));
  });
}
