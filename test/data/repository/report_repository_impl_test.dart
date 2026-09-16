import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/data/datasource/report/report_datasource.dart';
import 'package:ddara/data/repository/report_repository_impl.dart';
import 'package:ddara/domain/model/report/comment_report_reason.dart';
import 'package:ddara/domain/model/report/group_report_reason.dart';
import 'package:ddara/domain/model/report/report_reason.dart';
import 'package:ddara/domain/model/report/user_report_reason.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReportDataSource extends Mock implements ReportDataSource {}

DioException _dioError({String? code}) {
  final req = RequestOptions(path: '/api/reports');
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: 400,
      data: code == null ? null : {'code': code},
    ),
  );
}

void main() {
  late MockReportDataSource dataSource;
  late ReportRepositoryImpl repository;

  setUp(() {
    dataSource = MockReportDataSource();
    repository = ReportRepositoryImpl(dataSource);

    when(
      () => dataSource.reportShot(
        shotId: any(named: 'shotId'),
        reasonCode: any(named: 'reasonCode'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => dataSource.reportComment(
        commentId: any(named: 'commentId'),
        reasonCode: any(named: 'reasonCode'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => dataSource.reportUser(
        userId: any(named: 'userId'),
        groupId: any(named: 'groupId'),
        reasonCode: any(named: 'reasonCode'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => dataSource.reportGroup(
        groupId: any(named: 'groupId'),
        reasonCode: any(named: 'reasonCode'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenAnswer((_) async {});
  });

  test('reportShot 은 reason 을 서버 code 문자열로 변환해 위임한다', () async {
    await repository.reportShot(shotId: 1, reason: ReportReason.obscene);

    verify(
      () => dataSource.reportShot(
        shotId: 1,
        reasonCode: ReportReason.obscene.code,
        reasonText: null,
      ),
    ).called(1);
  });

  test('reportComment 는 SHOT_NOT_FOUND 코드를 ShotNotFoundException 으로 변환한다', () async {
    when(
      () => dataSource.reportComment(
        commentId: any(named: 'commentId'),
        reasonCode: any(named: 'reasonCode'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenThrow(_dioError(code: 'SHOT_NOT_FOUND'));

    expect(
      () => repository.reportComment(
        commentId: 1,
        reason: CommentReportReason.sexual,
      ),
      throwsA(isA<ShotNotFoundException>()),
    );
  });

  test('reportUser 는 GROUP_NOT_FOUND 코드를 GroupNotFoundException 으로 변환한다', () async {
    when(
      () => dataSource.reportUser(
        userId: any(named: 'userId'),
        groupId: any(named: 'groupId'),
        reasonCode: any(named: 'reasonCode'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenThrow(_dioError(code: 'GROUP_NOT_FOUND'));

    expect(
      () => repository.reportUser(
        userId: 1,
        groupId: 2,
        reason: UserReportReason.nickname,
      ),
      throwsA(isA<GroupNotFoundException>()),
    );
  });

  test('reportGroup 은 매칭되지 않는 code 를 NetworkException 으로 변환한다', () async {
    when(
      () => dataSource.reportGroup(
        groupId: any(named: 'groupId'),
        reasonCode: any(named: 'reasonCode'),
        reasonText: any(named: 'reasonText'),
      ),
    ).thenThrow(_dioError());

    expect(
      () => repository.reportGroup(groupId: 1, reason: GroupReportReason.etc),
      throwsA(isA<NetworkException>()),
    );
  });
}
