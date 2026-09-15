import 'package:ddara/domain/model/report/user_report_reason.dart';
import 'package:ddara/domain/repository/report_repository.dart';
import 'package:ddara/domain/usecase/report/report_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReportRepository extends Mock implements ReportRepository {}

void main() {
  late MockReportRepository repository;
  late ReportUserUseCase useCase;

  setUpAll(() {
    registerFallbackValue(UserReportReason.nickname);
  });

  setUp(() {
    repository = MockReportRepository();
    useCase = ReportUserUseCase(repository);

    when(
      () => repository.reportUser(
        userId: any(named: 'userId'),
        groupId: any(named: 'groupId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async {});
  });

  test('userId·groupId·reason·reasonText 를 그대로 Repository 에 위임한다', () async {
    await useCase.call(
      userId: 1,
      groupId: 2,
      reason: UserReportReason.nickname,
      reasonText: '설명',
    );

    verify(
      () => repository.reportUser(
        userId: 1,
        groupId: 2,
        reason: UserReportReason.nickname,
        reasonText: '설명',
      ),
    ).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.reportUser(
        userId: any(named: 'userId'),
        groupId: any(named: 'groupId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call(
        userId: 1,
        groupId: 2,
        reason: UserReportReason.nickname,
      ),
      throwsA(isA<Exception>()),
    );
  });
}
