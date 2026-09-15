import 'package:ddara/domain/model/group/group_list.dart';
import 'package:ddara/domain/repository/group_repository.dart';
import 'package:ddara/domain/usecase/group/get_group_list_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late GetGroupListUseCase useCase;

  setUp(() {
    repository = MockGroupRepository();
    useCase = GetGroupListUseCase(repository);
  });

  test('Repository 의 결과를 그대로 반환한다', () async {
    const list = GroupList(groups: []);
    when(() => repository.getGroupList()).thenAnswer((_) async => list);

    final result = await useCase.call();

    expect(result, list);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.getGroupList()).thenThrow(Exception('fail'));

    expect(() => useCase.call(), throwsA(isA<Exception>()));
  });
}
