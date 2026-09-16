import 'package:ddara/domain/model/report/group_report_reason.dart';
import 'package:ddara/domain/repository/report_repository.dart';
import 'package:ddara/domain/usecase/report/report_group_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReportRepository extends Mock implements ReportRepository {}

void main() {
  late MockReportRepository repository;
  late ReportGroupUseCase useCase;

  setUpAll(() {
    registerFallbackValue(GroupReportReason.etc);
  });

  setUp(() {
    repository = MockReportRepository();
    useCase = ReportGroupUseCase(repository);

    when(
      () => repository.reportGroup(
        groupId: any(named: 'groupId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async {});
  });

  test('groupId·reason·reasonText 를 그대로 Repository 에 위임한다', () async {
    await useCase.call(
      groupId: 1,
      reason: GroupReportReason.etc,
      reasonText: '설명',
    );

    verify(
      () => repository.reportGroup(
        groupId: 1,
        reason: GroupReportReason.etc,
        reasonText: '설명',
      ),
    ).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.reportGroup(
        groupId: any(named: 'groupId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call(groupId: 1, reason: GroupReportReason.etc),
      throwsA(isA<Exception>()),
    );
  });
}
