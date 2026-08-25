import 'package:ddara/core/exception/login_exception.dart';
import 'package:ddara/core/exception/report_exception.dart';
import 'package:ddara/domain/model/report/comment_report_reason.dart';
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
  Future<void> reportComment({
    required int commentId,
    required CommentReportReason reason,
    String? reasonText,
  }) async {
    try {
      await _reportDataSource.reportComment(
        commentId: commentId,
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
  /// (매칭되는 code 가 없으면 네트워크 오류로 본다)
  Exception _toException(DioException e) {
    final code = e.response?.data is Map ? e.response?.data['code'] : null;
    return ReportException.fromCode(code) ?? NetworkException();
  }
}
