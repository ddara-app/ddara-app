import 'package:ddara/domain/model/report/report_reason.dart';
import 'package:ddara/domain/repository/report_repository.dart';
import 'package:ddara/domain/usecase/report/report_shot_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReportRepository extends Mock implements ReportRepository {}

void main() {
  late MockReportRepository repository;
  late ReportShotUseCase useCase;

  setUpAll(() {
    registerFallbackValue(ReportReason.obscene);
  });

  setUp(() {
    repository = MockReportRepository();
    useCase = ReportShotUseCase(repository);

    when(
      () => repository.reportShot(
        shotId: any(named: 'shotId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async {});
  });

  test('shotId·reason·reasonText 를 그대로 Repository 에 위임한다', () async {
    await useCase.call(shotId: 1, reason: ReportReason.obscene, reasonText: '설명');

    verify(
      () => repository.reportShot(
        shotId: 1,
        reason: ReportReason.obscene,
        reasonText: '설명',
      ),
    ).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.reportShot(
        shotId: any(named: 'shotId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call(shotId: 1, reason: ReportReason.obscene),
      throwsA(isA<Exception>()),
    );
  });
}
