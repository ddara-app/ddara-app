import 'package:ddara/core/exception/group_exception.dart';
import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/report_error_code.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/domain/model/report/group_report_reason.dart';
import 'package:ddara/domain/model/report/report_reason.dart';
import 'package:ddara/domain/model/report/user_report_reason.dart';
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
      throw _toException(e);
    }
  }

  @override
  Future<void> reportUser({
    required int userId,
    required int groupId,
    required UserReportReason reason,
    String? reasonText,
  }) async {
    try {
      await _reportDataSource.reportUser(
        userId: userId,
        groupId: groupId,
        reasonCode: reason.code,
        reasonText: reasonText,
      );
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<void> reportGroup({
    required int groupId,
    required GroupReportReason reason,
    String? reasonText,
  }) async {
    try {
      await _reportDataSource.reportGroup(
        groupId: groupId,
        reasonCode: reason.code,
        reasonText: reasonText,
      );
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  /// 신고 접수 실패 응답을 도메인 예외로 변환한다. (사진·댓글·유저·모임 신고 공통)
  ///
  /// 401(UNAUTHORIZED)은 인터셉터에서 따로 처리하므로 여기서 다루지 않는다.
  Exception _toException(DioException e) {
    final code = e.response?.data is Map
        ? ReportErrorCode.fromValue(e.response?.data['code'])
        : null;

    switch (code) {
      case ReportErrorCode.invalidInput:
        // 400 — 필수값 누락, 본인 콘텐츠 신고, ETC 인데 reasonText 없음,
        // targetType 에 허용되지 않는 reasonCode, USER 인데 groupId 누락
        return InvalidReportInputException();

      case ReportErrorCode.notGroupMember:
        // 403 — 대상이 속한 모임의 멤버가 아님
        return NotGroupMemberException();

      case ReportErrorCode.shotNotFound:
        // 404 — 대상 없음 (운영 삭제된 사진·댓글 포함)
        return ShotNotFoundException();

      case ReportErrorCode.userNotFound:
        // 404 — 신고 대상이 해당 모임의 멤버가 아니거나 없음
        return ReportUserNotFoundException();

      case ReportErrorCode.groupNotFound:
        // 404 — 신고 대상 모임이 없음
        return GroupNotFoundException();

      default:
        return NetworkException();
    }
  }
}
