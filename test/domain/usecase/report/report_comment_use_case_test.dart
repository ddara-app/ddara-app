import 'package:ddara/domain/model/report/comment_report_reason.dart';
import 'package:ddara/domain/repository/report_repository.dart';
import 'package:ddara/domain/usecase/report/report_comment_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReportRepository extends Mock implements ReportRepository {}

void main() {
  late MockReportRepository repository;
  late ReportCommentUseCase useCase;

  setUpAll(() {
    registerFallbackValue(CommentReportReason.sexual);
  });

  setUp(() {
    repository = MockReportRepository();
    useCase = ReportCommentUseCase(repository);

    when(
      () => repository.reportComment(
        commentId: any(named: 'commentId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async {});
  });

  test('commentId·reason·reasonText 를 그대로 Repository 에 위임한다', () async {
    await useCase.call(
      commentId: 1,
      reason: CommentReportReason.sexual,
      reasonText: '설명',
    );

    verify(
      () => repository.reportComment(
        commentId: 1,
        reason: CommentReportReason.sexual,
        reasonText: '설명',
      ),
    ).called(1);
  });

  test('Repository 가 던진 예외를 그대로 전파한다', () async {
    when(
      () => repository.reportComment(
        commentId: any(named: 'commentId'),
        reason: any(named: 'reason'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenThrow(Exception('fail'));

    expect(
      () => useCase.call(commentId: 1, reason: CommentReportReason.sexual),
      throwsA(isA<Exception>()),
    );
  });
}
