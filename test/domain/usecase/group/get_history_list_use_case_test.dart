import 'package:ddara/domain/model/group/history_list.dart';
import 'package:ddara/domain/repository/group_repository.dart';
import 'package:ddara/domain/usecase/group/get_history_list_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late GetHistoryListUseCase useCase;

  setUp(() {
    repository = MockGroupRepository();
    useCase = GetHistoryListUseCase(repository);
  });

  test('groupId·year·month 를 그대로 Repository 에 위임한다', () async {
    const list = HistoryList(stats: HistoryStats(myCount: 1, totalCount: 2), cycles: []);
    when(
      () => repository.getHistoryList(1, year: 2026, month: 1),
    ).thenAnswer((_) async => list);

    final result = await useCase.call(1, year: 2026, month: 1);

    expect(result, list);
  });

  test('year·month 를 생략하면 null 로 위임한다', () async {
    const list = HistoryList(stats: HistoryStats(myCount: 0, totalCount: 0), cycles: []);
    when(
      () => repository.getHistoryList(1, year: null, month: null),
    ).thenAnswer((_) async => list);

    await useCase.call(1);

    verify(() => repository.getHistoryList(1, year: null, month: null)).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.getHistoryList(
        any(),
        year: any(named: 'year'),
        month: any(named: 'month'),
      ),
    ).thenThrow(Exception('fail'));

    expect(() => useCase.call(1), throwsA(isA<Exception>()));
  });
}
