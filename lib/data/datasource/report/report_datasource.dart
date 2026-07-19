import 'package:dio/dio.dart';

class ReportDataSource {
  ReportDataSource(this._dio);

  final Dio _dio;
  static final String _baseUrl = '/api/reports';

  /// 사진(SHOT)을 신고한다. (응답 본문 없음)
  Future<void> reportShot({
    required int shotId,
    required String reasonCode,
    String? reasonText,
  }) {
    return _report(
      targetType: 'SHOT',
      targetId: shotId,
      reasonCode: reasonCode,
      reasonText: reasonText,
    );
  }

  /// 댓글(COMMENT)을 신고한다. (응답 본문 없음)
  Future<void> reportComment({
    required int commentId,
    required String reasonCode,
    String? reasonText,
  }) {
    return _report(
      targetType: 'COMMENT',
      targetId: commentId,
      reasonCode: reasonCode,
      reasonText: reasonText,
    );
  }

  /// 신고 접수 공통 요청. (targetType 으로 사진·댓글 등을 구분)
  Future<void> _report({
    required String targetType,
    required int targetId,
    required String reasonCode,
    String? reasonText,
  }) async {
    await _dio.post(
      _baseUrl,
      data: {
        'targetType': targetType,
        'targetId': targetId,
        'reasonCode': reasonCode,
        'reasonText': reasonText,
      },
    );
  }
}
