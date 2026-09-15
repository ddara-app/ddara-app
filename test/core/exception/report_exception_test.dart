import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportException.fromCode', () {
    test('INVALID_INPUT → InvalidReportInputException', () {
      expect(
        ReportException.fromCode('INVALID_INPUT'),
        isA<InvalidReportInputException>(),
      );
    });

    test('NOT_GROUP_MEMBER → NotGroupMemberException (group_exception 공용)', () {
      expect(
        ReportException.fromCode('NOT_GROUP_MEMBER'),
        isA<NotGroupMemberException>(),
      );
    });

    test('SHOT_NOT_FOUND → ShotNotFoundException', () {
      expect(ReportException.fromCode('SHOT_NOT_FOUND'), isA<ShotNotFoundException>());
    });

    test('USER_NOT_FOUND → ReportUserNotFoundException', () {
      expect(
        ReportException.fromCode('USER_NOT_FOUND'),
        isA<ReportUserNotFoundException>(),
      );
    });

    test('GROUP_NOT_FOUND → GroupNotFoundException (group_exception 공용)', () {
      expect(
        ReportException.fromCode('GROUP_NOT_FOUND'),
        isA<GroupNotFoundException>(),
      );
    });

    test('매칭되지 않는 code 는 null', () {
      expect(ReportException.fromCode('UNKNOWN_CODE'), isNull);
    });

    test('code 가 null 이어도 null', () {
      expect(ReportException.fromCode(null), isNull);
    });
  });
}
