import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/report_error_code.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/core/model/report/report_reason.dart';
import 'package:ddara/data/datasource/report/report_datasource.dart';
import 'package:ddara/domain/repository/report_repository.dart';
import 'package:dio/dio.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportDataSource _reportDataSource;

  ReportRepositoryImpl(this._reportDataSource);

  @override
  Future<void> reportShot({
    required int shotId,
    required ReportReason reason,
    String? reasonText,
  }) async {
    try {
      await _reportDataSource.reportShot(
        shotId: shotId,
        reasonCode: reason.code,
        reasonText: reasonText,
      );
    } on DioException catch (e) {
      final code = e.response?.data is Map
          ? ReportErrorCode.fromValue(e.response?.data['code'])
          : null;

      // 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
      switch (code) {
        case ReportErrorCode.invalidInput:
          // 400 — 필수값 누락, 본인 사진 신고, ETC 인데 reasonText 없음
          throw InvalidReportInputException();

        case ReportErrorCode.notGroupMember:
          // 403 — 해당 사진이 속한 모임의 멤버가 아님
          throw NotGroupMemberException();

        case ReportErrorCode.shotNotFound:
          // 404 — 사진 없음 (운영 삭제된 사진 포함)
          throw ShotNotFoundException();

        default:
          throw NetworkException();
      }
    }
  }
}
