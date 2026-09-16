import 'package:ddara/domain/model/group/history_cycles.dart';
import 'package:ddara/domain/repository/group_repository.dart';
import 'package:ddara/domain/usecase/group/get_history_cycles_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository repository;
  late GetHistoryCyclesUseCase useCase;

  setUp(() {
    repository = MockGroupRepository();
    useCase = GetHistoryCyclesUseCase(repository);
  });

  test('groupId 를 그대로 Repository 에 위임하고 결과를 반환한다', () async {
    const cycles = HistoryCycles(cycles: []);
    when(() => repository.getHistoryCycles(1)).thenAnswer((_) async => cycles);

    final result = await useCase.call(1);

    expect(result, cycles);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(() => repository.getHistoryCycles(any())).thenThrow(Exception('fail'));

    expect(() => useCase.call(1), throwsA(isA<Exception>()));
  });
}
